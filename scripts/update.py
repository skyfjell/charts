import subprocess
import os
import shutil
import yaml

REPO = "https://github.com/keycloak/keycloak-operator.git"
TGT_DIR = "/tmp/kcop"
CWD = os.path.abspath(os.path.dirname(__file__))


def clone_repo():
    os.makedirs(TGT_DIR)
    subprocess.run(["git", "clone", REPO, TGT_DIR])


def kc_tags():
    return set(
        subprocess.run(["git", "tag"], cwd=TGT_DIR, stdout=subprocess.PIPE)
        .stdout
        .decode()
        .strip()
        .split('\n')
    )


def our_tags():
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
    kc = kc_tags()
    our = our_tags()
    cur = open_branches()
    return our.union(kc) - kc - cur


def generate_tag(tag_name):
    subprocess.run(["git", "checkout", tag_name], cwd=TGT_DIR)
    subprocess.run(["git", "checkout", "main"])

    templates = os.path.join(CWD, "keycloak-operator", "templates")
    crds = os.path.join(TGT_DIR, "deploy", "crds")

    shutil.rmtree(templates)
    os.makedirs(templates)

    for f in os.listdir(crds):
        shutil.copyfile(os.path.join(crds, f), os.path.join(templates, f))
    for f in ["role.yaml", "role_binding.yaml", "service_account.yaml", "operator.yaml"]:
        shutil.copyfile(os.path.join(TGT_DIR, "deploy", f), os.path.join(templates, f))

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
    # subprocess.run(["git", "tag", "-l", f"keycloak-operator-{tag_name}"])
    subprocess.run(["git", "push", "--set-upstream", "origin", f"keycloak-operator/{tag_name}"])


    
if __name__ == "__main__":
    clone_repo()

    tags = sorted(missing_tags())
    for tag in tags[:2]:
        generate_tag(tag)