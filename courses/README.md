# 📚 Courses

One folder per course. **Course tasks are not committed** — the university
does not allow it, and `.gitignore` enforces it. Only these files are tracked
under `courses/`:

- `README*` — how to work in that course
- `requirements*.txt` — Python dependencies
- `check_env.py` — environment smoke test

Your task files stay on your machine.

## 🐍 Python courses

Each course gets its own virtual environment, so its dependencies do not
collide with another course's.

```bash
cd courses/data.ml.100
python3 -m venv venv            # create it (once)
source venv/bin/activate        # activate it (every new terminal)
pip install -r requirements.txt # install the pinned dependencies
python3 my_task.py
```

`deactivate` leaves the venv. The `venv/` folder is git-ignored; everyone
recreates it from `requirements.txt`.

## ⚙️ C and C++ courses

The repo's `Taskfile.yml` picks the compiler from the course in the path:
cs.120 builds with `gcc -std=c11`, cs.110 / cs.111 / cs.115 with
`g++ -std=c++17`. Run these from the repo root:

```bash
task build -- courses/cs.120/my_task.c        # compile
task run   -- courses/cs.120/my_task.c 5 2    # compile and run with arguments
task clean                                    # delete compiled binaries
```

The binary lands next to the source with the extension stripped, and is
git-ignored like the source.
