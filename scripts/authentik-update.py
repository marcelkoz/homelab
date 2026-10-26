import subprocess

def read_tags(file_path):
    with open(file_path, "r") as f:
        return list(filter(lambda line: line != "", [line.strip() for line in f]))

CONTAINER_IMAGE_PREFIX="ghcr.io/goauthentik/server:"
CONTAINER_MAIN_NAME="authentik"
CONTAINER_WORKER_NAME="authentik-worker"

CONTAINER_TAGS=read_tags("tags.txt")
CONTAINER_IMAGES=list(map(lambda tag: CONTAINER_IMAGE_PREFIX + tag, CONTAINER_TAGS))

def confirmation_input(message):
    while True:
        user_input = input(message + "\nDo you want to proceed? (y/n):").lower()
        if user_input in ['y', 'yes']:
            return True
        elif user_input in ['n', 'no']:
            return False

def important(*message):
    print(f"!!! {'\n'.join(message)} !!!")

def run_docker_command(*args):
    command = ["sudo", "docker"] + list(args)
    print(f"Running command: {' '.join(command)}")
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error running command: {result.stderr}")
    else:
        print(result.stdout)

def update_loop():
    for image in CONTAINER_IMAGES:
        important(f"pulling {image}")
        run_docker_command("pull", image)

        update = confirmation_input(f"Ready to update authentik to {image}")
        if not update:
            print("ABORTING")
            return

        important("stopping containers")
        run_docker_command("compose", "down", CONTAINER_MAIN_NAME, CONTAINER_WORKER_NAME)

        # TODO: move tag

def main():
    start = confirmation_input(f"Authentik images will be updated in the following version order:\n{"\n".join(map(lambda tag: "   - " + tag, CONTAINER_TAGS))}")
    if not start:
        print("ABORTING")
        return

    update_loop()

if __name__ == "__main__":
    main()
