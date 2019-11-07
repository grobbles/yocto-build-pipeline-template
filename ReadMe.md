# Yocto Build Pipeline Template

## Description

## Git Workflow

-   master branch
-   feature branch
-   bugfix branch

If you want to add a new feature than create a new branch from master branch and commit your stuff to the branch. If you think you are done than create a merge request and add me (Uwe Roder) as reviewer.

## Software versioning

It give three segments (Major version).(Minor version).(Patch version)

1. Major version - incremented for backwards-incompatible changes
    - Major version must be incremented manually in the 'setup.py' file.
    - It will be read only the Major version from the file. The other version numbers will be ignore and will be override from script.
2. Minor version - incremented for new, backwards-compatible functionality is introduced to the API
    - Minor version will be incremented automatically if a feature branch merged in the master branch.
3. Patch version - incremented for backwards-compatible bug fixes
    - Patch version will be incremented automatically if a bugfix branch merged in the master branch.

Example:

```python
    0.9.0 # merge a bugfix branch
    0.9.1 # merge a bugfix branch
    0.9.2 # merge a bugfix branch
    ...
    0.9.10
    0.9.11
    1.0.0 # the project is in a stable state and can be release.
    1.0.1 # merge a bugfix branch
    1.1.0 # merge a feature branch
    2.0.0 # merge a feature branch with a incompatible API change
    2.0.1 # merge a bugfix branch
    ...
```

## Next Features
