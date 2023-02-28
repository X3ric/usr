#!/bin/bash
x=$(fzf)
thunar ${x%/*}     