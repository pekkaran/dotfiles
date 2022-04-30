# Keymaps

Given the file `xkbmap_us` Set the keymap like this:

```bash
xkbcomp -I$HOME/.xkb ~/.xkb/keymap/xkbmap_us $DISPLAY &> /dev/null
```

The available keymaps are listed in the file `/usr/share/X11/xkb/rules/base.lst`.

## The best base layout

After experimenting with several US layouts, I found the `altgr-intl` to be the best for me.With the default US map there is no good way to type Scandinavian letters. With the `intl` variant `Altgr+q/p` give `ä` and `ö` respectively. However some keys, including `'` are "dead", meaning you have to press space for them to appear (or another letter which they will modify, like place dots over `a` to form `ä`). `altgr-intl` doesn't have dead keys. Also the `alt-intl` variant didn't seem to work as I expected.

Set it in the config file by: `us(altgr-intl)` (the variant names go inside parentheses).

## My additions

The keymap I normally use is `xkbmap_us_custom`, see its contents for details. Also see `xkbsymbols`. I'll part with a warning that after you create your dream layout it will quickly become a pain to use other computers and OSs where you don't have your custom keymap available…
