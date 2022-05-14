## MongoDB
### Recommendation
If you use a replicaSet, include in your EXTRA_PARAMS readPreference=secondary for best performance

## Docker
### Build and Run
```
docker build . -t mongodb-backup && docker run --env-file=".env" mongodb-backup
```

### Build from M1 to X86
If you have a Mac with M1 chip and you want to build for x86 hadware, you can use this:
```
docker buildx build --platform=linux/amd64 . -t mongodb-backup
```

## Kubernetes
You can run a cronjob task with 200m of CPU and 256Mi of RAM.
