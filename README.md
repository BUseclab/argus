Argus
=========

This repository contains the artifacts for our prototype implementation of Argus, described in our USENIX 2024 paper.

Argus is a hybrid static-dynamic analysis of PHP interpreters that identifies PHP APIs vulnerable to injection. We provide instructions for building Argus's individual components.

## Instruction

The evaluation of this artifact is divided into two separate phases:

1. Analysis of the PHP interpreter
    - Argus generates the PHP interpreter's call graph.
    - Next, Argus merges the statically generated call graph with the already recorded dynamic traces of PHP unit tests.
    - Finally, Argus performs a reachability analysis on the call graph to identify PHP APIs that lead to insecure deserialization.
2. Extending a static taint analysis tool, Psalm
    - Extending Psalm based on the information collected above.
    - Run an extended Psalm on a real-world WordPress plugin.

To facilitate the evaluation of Argus, most of our instructions are based around Docker containers. In order to run Argus, please use this [link](https://docs.docker.com/get-docker/) to install Docker. Next, 


## Phase 0 - Preparation
In order to run the containers, you need to download the artifact and import it to Docker. Please use the following link to download the container for phase 1 and 2 of the evaluation.

<p align="center">
<a href="https://zenodo.org/records/12137522">
<img src="argus-artifact.svg">
</a>
</p>

Next, import the container using the following command:
```bash
docker import argus-artifact.tar argus-artifact:1.0

## If you do docker images, you should see the container listed.
```

## Phase 1 - Identification

In order to run Argus, first run the container using the following command:
```bash
docker run --rm --workdir /home -it argus-artifact:1.0 bash
```

After running the container, we need to perform a basic test prior to running Argus. To do so, please run the following command:
```bash
cd step-1 $$ ./prepare.sh
```
The above command may take a few minutes to complete. Next, you can run Argus' analysis by executing the following command in the `step-1` directory:
```bash
./run.sh
```
At the end of this analysis, Argus creates a file named `list` in the `step-2` directory, which includes a set of potential insecure deserialization APIs. In order to run the validation test, please execute the following command:

```bash
cd /home/step-2 && ./run.sh
```
The validation step in Argus uses the compiled PHP from the previous step and the `list` file to dynamically generate PHP snippet code for each PHP API and analyze the execution. If there is a deserialization during execution, Argus marks the PHP API as `vulnerable`.


The organization of Argus' container is as follows:
```bash
.
|-- step-1              # Inlcudes the scripts and codebase Argus and PHP5.6 
    |-- argus           
        |-- analyze.pyc # Main script which anlayzes PHP interpreter and identifies the APIs
        |-- enum        # The PHP extension to extract PHP APIs addresses
        |-- graph_**    # Previously recorded function traces of running PHP unit tests
    |-- php-src         # The souce code of PHP interpreter v5.6
    |-- clean_up.sh     # Cleans up the container
    |-- prepare.sh      # Compiles PHP and our extension and runs basic tests
    |-- run.sh          # Runs the Argus' analysis
|-- step-2              # Includes the scripts and payload for validation process
```


## Phase 2 - Extension

By the end of phase 1, Argus identifies the set of PHP APIs that lead to deserialization in PHP5.6. In this phase, we demonstrate that by extending existing static analysis tools using Argus' results, we can detect previously unknown vulnerabilities. Please use the following command to build and run the container:

```bash
cd phase-3 && ./run all
```

Now we have a shell from the container. Next, we run Psalm without any extension using the following command on a WordPress plugin from our paper's dataset, called ImageMagick.

```bash
./run.sh
```

Psalm identifies four potential vulnerabilities in Imagemagick; none of them are insecure deserialization.


Finally, we extend Psalm to include `is_executable` as an insecure deserialization taint sink, and use the following command to analyze the plugin once more:

```bash
./run.sh 1
```

The extended Psalm identifies six vulnerabilities, where the two newly identified issues are insecure deserialization.

## BibTeX for citation
```
@inproceedings {argus,
author = {Rasoul Jahanshahi and Manuel Egele},
title = {Argus: All your (PHP) Injection-sinks are belong to us.},
booktitle = {{USENIX} Security Symposium},
year = {2024},
publisher = {{USENIX} Association},
month = Aug,
}

```

## Contact us

If you require any further information, send an email to `rasoulj@bu.edu`