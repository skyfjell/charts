#!/bin/python3

import subprocess
import os
import shutil
import yaml

REPO = "https://github.com/keycloak/keycloak-operator.git"
CWD = os.path.abspath(os.path.dirname(__file__))
REPO_DIR = os.path.abspath(os.path.join(CWD, ".."))


def kc_tags():
    print("Gathering tags on keycloak-operator")
    raws = set(
        x.split("\t")[1].strip("refs/tags/") for x in 
        subprocess.run(["git", "ls-remote", "--tags", REPO], stdout=subprocess.PIPE)
        .stdout
        .decode()
        .strip()
        .split('\n')
        )    
    return set([x for x in raws if int(x.split(".")[0]) >= 15 ])# 15.0.0 init version
    


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
    ours = our.union(cur)
    result = kc - ours
    return result

def write_operator(tag_name):
    out = subprocess.run(["kubectl", "kustomize", f"{REPO}/deploy?ref={tag_name}"], stdout=subprocess.PIPE).stdout.decode()
    with open(os.path.join(REPO_DIR, "keycloak-operator", "templates", "operator.yaml"), "w") as f:
        f.write(out)


def generate_pr(tag_name):
    subprocess.run(["git", "checkout", "-b", f"keycloak-operator/{tag_name}"])
    write_operator(tag_name)
    diff = subprocess.run(["git", "status", "-s"], stdout=subprocess.PIPE).stdout.decode()
    if diff == "":
        return False 
    
    chartyaml = os.path.join(REPO_DIR, "keycloak-operator", "Chart.yaml")
    with open(chartyaml) as f:
        data = yaml.load(f, Loader=yaml.FullLoader)
    data["version"] = f"{tag_name}"
    data["appVersion"] = str(tag_name)

    with open(chartyaml, "w") as f:
        yaml.dump(data, f)

    subprocess.run(["git", "add", "-A"])
    subprocess.run(["git", "commit", "-m", f'"Auto commit for new keycloak-operator tag {tag_name}"'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    subprocess.run(["git", "push", "--set-upstream", "origin", f"keycloak-operator/{tag_name}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return True
    
if __name__ == "__main__":

    tags = sorted(missing_tags(), key=lambda x: tuple(int(i) for i in x.split('.')))
    print(f"Running tags {tags}")
    for tag in tags:
        if generate_pr(tag):
            break