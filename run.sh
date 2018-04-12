#!/bin/bash


docker run -e USER='name' -e EMAIL_ADDRESS='name@gmail.com' --name="geogig" -p 38080:8182  -d  kartoza/geogig

