# Mounting/Unmounting Volumes

## Primary Goal

1. Mount `/dev/vdX` into `/volX`
1. Change mount point to user specified mount point.  If mounted fail out and do not try to re-mount under a different directory
1. If not mounted, mount in user specified path.

## Secondary Goal

<https://github.com/iPlantCollaborativeOpenSource/atmosphere/blob/master/service/task.py#L94-L152>

1. Try to unmount
1. If mount fails, identify files that are holding mount
1. Soft kill processes
1. Hard kill processes
