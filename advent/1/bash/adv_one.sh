#!/bin/bash
cat ../input.txt | sed "s/(/1+/g" | sed "s/)/0-1+/g" | sed "s/+$//" | bc
