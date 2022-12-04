import subprocess

registry = [
    { "name": "all" },
    { "name": "system" },
    { "name": "fonts" },
    { "name": "fzf" },
    { "name": "go" },
    { "name": "nvim", "dependencies": ["nvm", "pyenv", "ripgrep"] },
    { "name": "nvm" },
    { "name": "pyenv" },
    { "name": "ripgrep" },
    { "name": "lazygit" },
]

status = {}

def install_everything():
    for index in range(len(registry)):
        install_package(index)


def install_dependencies(dependencies):
    for required in dependencies:
        for index, package in enumerate(registry):
            if package["name"] == required:
                print(f"\tdepends on {package['name']}")
                install_package(index)


def run_script(script):
    print(f"installing {script}")
    proc = subprocess.Popen(script, shell=True)
    code = proc.wait()
    if code == 0:
        status[script] = True
    else:
        status[script] = False
        print(proc.stderr.read().decode("utf-8"))


def install_package(option):
    name = registry[option]["name"]
    script = f"./{name}.bash"

    if name in status:
        return

    install_dependencies(registry[option].get("dependencies", []))
    run_script(script)



for index, package in enumerate(registry):
    print(index, package["name"], package.get("requires", ""))

options = input("what packages do you want to install? ").split(" ")
for option in filter(lambda x: x, options):
    option = int(option)
    if option == 0:
        install_everything()
    else:
        install_package(option)


for k, v in status.items():
    print(k, v)
