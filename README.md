# GHS Robotics — Summer Program 🤖

Welcome! This repository is where your robot's code lives. Over two weeks you'll **design, build, code, and drive** a real VEX V5 robot. This page tells you how to get started and what we expect from you.

---

## Getting started (Day 1)

Everything runs in your browser — no installs, works on a Chromebook.

1. **Sign in to [github.com](https://github.com).** If you don't have an account yet, create one — you can sign up with your Gmail address.
2. Go to **https://github.com/NeevtheHacker/GHS-RoboStarter** and click the green **"Use this template" → Create a new repository.** Put it under **your own account** and name it after yourself (e.g. `alex-robot`).
3. On *your* new repo: **Code → Codespaces → Create codespace on main.**
4. **Wait at least 5 minutes** the first time — it's downloading the compiler and setting everything up. ⏳
   - While it sets up, VS Code may pop up prompts like *"Install the PROS toolchain?"*, *"Install the Makefile Tools extension?"*, or *"configure this project?"*. **Say No / Don't / dismiss on all of them** — everything you need is already installed by the container. Installing extra copies will only cause problems.
5. When it's ready, open the terminal at the bottom and run:
   ```
   pros make
   ```
   If it builds, you're ready to go. 🎉

> **Watching the setup (useful if something looks stuck):** open the Command Palette
> (**Ctrl/Cmd + Shift + P**) and run **"Codespaces: View Creation Log."** That shows the
> container build — you should see the toolchain download and, near the end, a line like
> `arm-none-eabi-gcc ... 13.3.1`. If the log finished and shows that line, setup worked.

---

## How each day works

- **Start (10 min):** write your goals for the day in your notebook.
- **Middle:** you rotate between **building** the robot and the **coding session**, with **driving time** on the practice robots.
- **End (10 min):** put every part back in its bin, and **stop your codespace**.

---

## What we expect from you ⭐

- **Work together, work hard.** Progress comes from the whole team pushing through problems — not one person, not one lucky idea. We notice and celebrate **effort and improvement**, not just who's fastest.
- **Design before you build.** Sketch it (or CAD it) *first*, then build. Every time. This is the habit we care about most.
- **Use Git properly.** Make a branch, commit with a clear message, and open a pull request. (How-to below.)
- **Understand the code — don't just copy it.** If you can't explain what a line does, ask. (For LemLib, being able to explain how it works is actually a competition rule.)
- **Share the robot.** Take your driving turn, and make sure others get theirs.
- **Clean up.** Parts back in their bins against the checklist; stop or delete your codespace when you leave.
- **Be safe and kind.** Follow Mr. Angelo's directions, no food in the room, and look out for each other.

---

## The Git workflow (what you'll do most days)

Start a change on your own branch:
```
git checkout -b my-change      # start a branch
# ...edit the code...
git add .
git commit -m "what I changed"
git push -u origin my-change   # send it to GitHub
```
Then on GitHub, open a **Pull Request** so a lead can review it.

Before you start each day, get the latest:
```
git checkout main
git pull
```

---

## Understanding your code

Your robot code is in **`src/main.cpp`**, organized in sections you'll unpack over the week:

- **Config & Devices** — which motors are on which ports
- **Drivetrain & Odometry** — how the robot moves and knows where it is
- **Driver control** — the joysticks feed `chassis.arcade(...)`
- **Autonomous** — driving by position with `moveToPoint`

Read it top to bottom; each part gets covered in a session.

## Putting your code on a real robot

Your browser can **build** the code but can't reach the robot over the internet. So: push your code, then load it at one of the two **upload-station laptops** (plugged into a robot with a cable).

---
---

## 🔧 For instructors / maintainers — setup notes (canonical)

This section is the verified setup record for whoever runs or rebuilds this next.

**Environment:** GitHub Codespaces + a dev-container (`.devcontainer/`). All versions pinned and tested.
- **Image:** `mcr.microsoft.com/devcontainers/cpp:ubuntu-22.04` (jammy — its pip predates the PEP-668 lock, so `sudo pip3 install` works).
- **Toolchain:** Arm GNU Toolchain **13.3.rel1**, installed by `.devcontainer/setup.sh` from `developer.arm.com`. PROS CLI installed system-wide. `PROS_TOOLCHAIN` + `PATH` are pinned in `devcontainer.json` (verified: `pros make` prepends `$PROS_TOOLCHAIN/bin`).

**⚠️ The key compatibility fact (this cost an afternoon to find):**
> PROS **kernel 4.2.2** pairs with **GCC 13.3** only when the C/C++ standards are `gnu2x` / `gnu++23`. A fresh 4.2.2 template defaults to `gnu23` / `gnu++26`, which are **GCC-14** names and fail on 13.3. So the `Makefile` pins:
> ```make
> C_STANDARD:=gnu2x
> CXX_STANDARD:=gnu++23
> ```
> (These are exactly what last season's `cardbot` used, against the same libraries.) The alternative is to install `arm-gnu-toolchain-14.2.rel1` and leave the template defaults — but the pin above is simpler and re-download-free.

**Making the template:** push the repo, then **Settings → check "Template repository."** Students "Use this template" to their **own** accounts, which keeps their Codespaces on the free personal quota.

**Verifying a build:** to confirm the container set up correctly, open the Command Palette → **"Codespaces: View Creation Log"** — you should see `setup.sh` run and print `arm-none-eabi-gcc ... 13.3.1` near the end. This is the fastest way to diagnose a student whose Codespace "isn't working." (There's also **"Codespaces: View Container Log"** for lower-level Docker output.)

**Before camp:** run the full flow once on an actual **lab Chromebook on the school network** and confirm GitHub + Codespaces domains aren't blocked — the last remaining Day-1 risk.

**Key files:**
- `.devcontainer/devcontainer.json`, `.devcontainer/setup.sh` — the environment
- `src/main.cpp` — the teaching code (simplified from last season's robot)
- Full-season reference: `github.com/GHSRoboticsClub/cardbot`