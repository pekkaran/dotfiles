#!/usr/bin/env python3

def main(args):
    pass

if __name__ == "__main__":
    import argparse
    p = argparse.ArgumentParser(__doc__)
    p.add_argument("inputPath", type=pathlib.Path)
    p.add_argument("--flag", action="store_true")
    args = p.parse_args()
    main(args)
