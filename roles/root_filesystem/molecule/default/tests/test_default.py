"""Role testing files using testinfra."""


def test_root_filesystem(host):
    """Validate root filesystem."""
    dev = host.block_device("/dev/vdb1")

    assert dev.is_partition
    assert dev.size == 2 * 1024 * 1024 * 1024
