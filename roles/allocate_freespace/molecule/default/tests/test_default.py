"""Role testing files using testinfra."""


def test_freespace(host):
    assert host.block_device("/dev/vdb2").is_partition
