---
description: >-
  Libraries and services may seem quite similar, but they have their
  differences. This page will go over the differences.
cover: ../.gitbook/assets/13.png
coverY: 0
---

# ❔ Libraries VS Services

## Overview

Libraries and Services are used for organizational purposes within Noir. They separate independent and reusable code from game affecting code.

See [What Are Libraries](libraries.md#what-are-libraries) and [What Are Services](services.md#what-are-services).

## What Are Services?

Services **manage and store data** and **act upon game events** (although not always).

Services may interact with each other in various ways or utilize libraries. However, a library should be considered if the code could be reused and doesn't affect the game directly.

## What Are Libraries?

Libraries contain code that can be used elsewhere, which is useful for **separation, organization, ease of use and reduced repeated code**.

Libraries shouldn't interact with services or the game directly, but they can utilize other libraries.\
A service should be considered if the code may affect the game or use game events.
