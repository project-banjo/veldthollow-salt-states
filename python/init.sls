python:
    pkg.installed:
        - names:
            - python3
            - python3-pip
            - python3-dev
            - python3-setuptools
            - python-pip

pillow_dependencies:
    pkg.installed:
        - names:
            - zlib1g
            - libjpeg-dev
            - libfreetype6-dev
        - require:
            - pkg: python

## PIL doesn't look in the right place, so we need a few symlinks
/usr/lib/libfreetype.so:
    file.symlink:
        - target: /usr/lib/x86_64-linux-gnu/libfreetype.so
        - require:
            - pkg: libfreetype6-dev

/usr/lib/libjpeg.so:
    file.symlink:
        - target: /usr/lib/x86_64-linux-gnu/libjpeg.so
        - require:
            - pkg: libjpeg-dev

/usr/lib/libz.so:
    file.symlink:
        - target: /usr/lib/x86_64-linux-gnu/libz.so
        - require:
            - pkg: zlib1g

# vim:set ft=yaml:
