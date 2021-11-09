import subprocess
import os
import shutil
import yaml

REPO = "https://github.com/keycloak/keycloak-operator.git"
TGT_DIR = "/tmp/kcop"
CWD = os.path.abspath(os.path.dirname(__file__))


def clone_repo():
    os.makedirs(TGT_DIR)
    print(f"Cloning into {TGT_DIR}")
    subprocess.run(["git", "clone", REPO, TGT_DIR])


def kc_tags():
    print("Gathering tags on keycloak-operator")
    return set(
        subprocess.run(["git", "tag"], cwd=TGT_DIR, stdout=subprocess.PIPE)
        .stdout
        .decode()
        .strip()
        .split('\n')
    )


def our_tags():
    print("Gathering tags on our repo")
    return set([
        x.strip("keycloak-operator-")
        for x in
        subprocess.run(["git", "tag"], stdout=subprocess.PIPE)
        .stdout
        .decode()
        .strip().
        split('\n')
    ])

def open_branches():
    print("Gathering open branches with `keycloak-operator` prefix")
    return set([
        x.strip("keycloak-operator/")
        for x in
        subprocess.run(["git", "branch"], stdout=subprocess.PIPE)
        .stdout
        .decode()
        .strip().
        split('\n')
        if "keycloak-operator/" in x
    ])

def missing_tags():
    print("Calculating new tags that aren't open branches")
    kc = kc_tags()
    our = our_tags()
    cur = open_branches()
    return our.union(kc) - kc - cur


def move_files(kc_tag_name):
    subprocess.run(["git", "checkout", kc_tag_name], cwd=TGT_DIR)

    print(f"Checking out {kc_tag_name} and looking for kustomize")

    kustomize = os.path.join(TGT_DIR, "deploy", "kustomization.yaml")
    if not os.path.isfile(kustomize):
        print("Unsupported tag, no kustomization.yaml")
        return

    with open(kustomize) as f:
        k = yaml.load(f, Loader=yaml.SafeLoader)
    return [os.path.abspath(os.path.join(TGT_DIR, "deploy",f)) for f in k.get("resources", []) if 'namespace' not in f]


def generate_pr(tag_name):
    subprocess.run(["git", "checkout", "main"])

    templates = os.path.join(CWD, "keycloak-operator", "templates")
    files = move_files(tag_name)

    shutil.rmtree(templates)
    os.makedirs(templates)

    for f in os.listdir(files):
        shutil.copyfile(files, os.path.join(templates, f))

    chartyaml = os.path.join(CWD, "keycloak-operator", "Chart.yaml")
    with open(chartyaml) as f:
        data = yaml.load(f, Loader=yaml.FullLoader)

    (maj, min, fix) = data["version"].split(".")
    min = int(min) + 1
    data["version"] = f"{maj}.{min}.{fix}"
    data["appVersion"] = f'"{tag_name}"'

    with open(chartyaml, "w") as f:
        yaml.dump(data)

    subprocess.run(["git", "checkout", "-b", f"keycloak-operator/{tag_name}"])
    subprocess.run(["git", "add", "-A"])
    subprocess.run(["git", "commit", "-m", f'"Auto commit for new keycloak-operator tag {tag_name}"'])
    subprocess.run(["git", "push", "--set-upstream", "origin", f"keycloak-operator/{tag_name}"])
    
if __name__ == "__main__":
    clone_repo()

    tags = sorted(missing_tags())[:1]
    print(f"Running tags {tags}")
    for tag in tags[:1]:
        generate_pr(tag)