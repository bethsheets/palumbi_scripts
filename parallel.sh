#!/bin/bash

parallel ./$1 ::: ${@:2}

