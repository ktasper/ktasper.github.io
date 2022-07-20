---
title: "Kubernetes The Hard Way"
date: 2022-07-20T19:20:39Z
draft: false
---

# Intro
As a DevOps engineer I use Kubernetes all the time. I feel like I have a grasp on using it as a DevOps engineer but I am naive in how its actually working on the OS level.
I am going to document my experiance with this repo: [Kubernetes the hard way - kelseyhightower](https://github.com/kelseyhightower/kubernetes-the-hard-way). But I want to use DevOpstooling. That means `terraform` for the infra, `bash` scripts to do the manual work and whatever else I feel I need to do this.

# Resources
- [My repo for the course](https://github.com/ktasper/kthw)
- [The course: Kubernetes the hard way](https://github.com/kelseyhightower/kubernetes-the-hard-way)


# Getting Setup

## Docker Image
I wanted a Docker container to contain all the tools I will use, This is found in [My repo for the course](https://github.com/ktasper/kthw).

## Google Cloud
I also created a service account on GCP with admin access. I saved this as `sandbox.json`. I also ensured to add that to my `.gitignore` straight away!
