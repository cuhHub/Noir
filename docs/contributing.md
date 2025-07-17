---
description: >-
  If you would like to contribute to Noir and implement features, make
  suggestions, etc, read on below! Feel free to skip this page if you're not
  planning on any of this though.
cover: .gitbook/assets/16.png
coverY: 0
---

# 🤝 Contributing

## Pull Requests

We absolutely welcome any pull requests. If you have any features or changes or fixes (etc) you'd like to implement, start with a PR.

### Style Guide

We don't really have a style guide set in stone, but generally try to adhere to these rules:

* Functions and methods should follow PascalCase.
* Add type checking for all functions and methods (major one!).
* Add annotations where possible (`---@param`, `---@return`, `---@type`, etc).
  * This is for intellisense provided by the Lua VSCode extension to make it easier for people to use Noir and is used by the code handling API reference docs generation.
  * For `---@return`, only the return type should be used. A name or description is not expected.
  * For `---@param`, the necessary argument type and name should be used. A description is not expected.
  * Consider using `fun(arg1: type, ...): returnType` instead of `function` for annotating function types.
* Variables in a local scope should follow camelCase.
* Class attributes should follow PascalCase.
* Use multi-line comments for method/function descriptions, not single-line comments.
* Try to provide code examples and detailed descriptions for methods/functions.

There are probably more to list. Consider looking at the Noir code to get an idea of what to follow. Don't worry too much though, styling can always be corrected during PR review.

### License

Noir is licensed under Apache 2.0. By contributing, you agree that your contributions will be licensed under the same Apache 2.0 license.

### Steps

1\) Fork the repo. Make sure your branch is created from `main`

2\) Implement your changes within the fork.

3\) If your code can be tested (any Lua code that can run outside of the game), please make tests for it in the `tests` directory. You can look at the already-existing tests to get an idea of how to make one.

4\) Ensure your tests pass locally. To run tests, simply run `py run_test.py` (depending on your OS,  use `python` or `python3` instead). Be sure to `pip install` requirements from `requirements.txt`. Tested on `Python 3.13`, may work on other `3.x` versions.

5\) Ensure the code runs fine in Stormworks. You can build your local Noir code by following the instructions in the `README.md` in the root folder in the Noir repo. You can then move the bundled `Noir.lua` file into a test addon to test your changes in-game.

6\) Once done, submit a PR from your fork and describe your changes thoroughly and why they were implemented and how they can be beneficial.

7\) Listen for feedback and address it and your PR should get accepted and implemented in a future Noir update if it's all good!

## Issues

Found a bug or want something added but can't code it yourself? Create an issue over on the Noir repo.

Explain what the issue is (Is it a bug? Is it a suggestion?) and go into detail if possible. Give whatever information necessary and listen out for replies.

