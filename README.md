

---

[AI Usage Note](#-ai-usage-note)

## Note About the Code Freeze

>**Note:**
> The source files of the app are in the directory 'src' instead of 'app'. This has already been cleared up.

>**Note:**
> Parts of this documentation have been enhanced with the help of AI tools. For more details, see the AI usage
note at the bottom of this page.

>**Note:**
> The initial commits in the project were made by the user 'abxod,' which is the GitHub account of Abdullah Sulimani.
> I have since corrected this.

# Project Vision

This app gives students living in dormitories—or even those nearby—a way to connect with others through casual, locally
arranged activities. Whether someone is looking to relax, meet new faces, or simply step away from daily routines, the
platform offers a low-barrier path to join, discover, or create events right in their immediate surroundings.

Communities inside the app are tied to real-world places and can be entered by scanning QR codes placed around the
property. This makes joining fast and uncomplicated, while also lending a sense of familiarity. The app’s design draws
from widely used social media platforms, so students can find their way around naturally, without much explanation.

The focus is on enjoyment, spontaneity, and shared experiences—especially during those times when university life
becomes a bit much. From film nights and study sessions to weekend barbecues, the app is meant to be a quiet reminder
that campus life doesn’t have to feel isolating.

# Work Matrix

Please complete the following list according to the instructions provided in the "Grading" section on Moodle before your final presentation.

- Lab 1+2 (User Research): 15%
- Lab 3 (Design...): 30%
- Lab 4+5 (Implementation, App): 50%
- Lab 6 (UX Evaluation): 5%


## Read This

This repo

- shows the publication with gitlab ci and gitlab pages of
  - [documentation](???) written in md-files using [mkdocs](https://www.mkdocs.org/)
  - the running flutter app as a [web app](???)
- contains templates for **new issues**, bugs and merge requests

## Getting started

1. find the url of the gitlab pages of your repository: go to deploy --> pages --> access pages. Make sure the checkbox with _Use unique domain_ is checked and saved.

- adapt ??? of this readme using the gitlab pages of your repository
- start coding in the folder app
  - an application with bottom navigation exists!
  - adapt the namespace, i.e. replace every occurrence of `de.hda.fbi.hci.DormConnect` with `de.hda.fbi.hci.DormConnect` -- do not use `-` in the namespace
  - adapt the project name, i.e. replace every occurrence of `DormConnect` with `DormConnect`
- start filling the pages in the folder docs
- use the build_runner (for freezed and e.g. riverpod)

```
dart run build_runner watch
```

- code quality: go to cid/cd --> pipelines --> click a pipeline --> code quality, see [gitlab code quality](https://docs.gitlab.com/ee/ci/testing/code_quality.html)
- check regularly for new lib versions `flutter pub outdated`

## Check and run the docs locally
Install docker or [docker desktop](https://www.docker.com/products/docker-desktop/). Make sure, docker runs.

### Windows, Linux, Mac with Intel
Open your cloned project with VS Code and start a terminal. 

Set Powershell as your default terminal in VS Code:
- Click the dropdown icon at the top-right of the terminal panel.
- Select default profile
- choose PowerShell from the list

Pull the container
```
  docker pull registry.code.fbi.h-da.de/hci-trapp-public/hci-docker/build-mkdocs
```

Run the container
```
docker run -p 0.0.0.0:8080:8080 -v  ${pwd}:/home -w /home -it registry.code.fbi.h-da.de/hci-trapp-public/hci-docker/build-mkdocs mkdocs serve
```
If you use windows cmd shell use `%cd%` for the current path, in linux/bash use `$(pwd)`. 

Open your browser with http://localhost:8080/ and check your docs.

### Mac M...
Start a terminal and navigate to your cloned repository or open a terminal in VS Code with your project.
Pull the container
```
  docker pull registry.code.fbi.h-da.de/hci-trapp-public/hci-docker/build-mkdocs-mac
```

Run the container 
```
docker run --name hci_mkdocs --rm -it -p 8000:8000 -v "$(pwd):/docs" registry.code.fbi.h-da.de/hci-trapp-public/hci-docker/build-mkdocs-mac 
```

Open your browser with http://localhost:8000/ and check your docs.

---

#### ✨ AI Usage Note

To improve clarity, consistency, and readability, sections of this README and the documentation were refined using
AI-assisted editing. This includes improvements in vocabulary, sentence structure, and the overall organization of
content. All edits were reviewed and approved to ensure accuracy and alignment with the project's goals.
