![Screenshot goes here](https://i.imgur.com/KIB2yD0.png)

A custom node for displaying REXPaint xp ANSI images.


Usage:
Add a RexSprite node, provide an (uncompressed) xp_file and font_texture (16x16 characters CP437 font image) and it should load and display ye tasty ANSI art.


The biggest annoyances for now are:
- It doesn't support gzipped xp files. You have to unzip them by hand before using. 
- I guess multiple layers may not work for some reason? I'm too lazy to look into this as I didn't need any layers yet.
- It's hideously slow. I couldn't figure out a way to efficiently blit glyphs onto a new texture so it's an ugly setpixels galore with some hacky optimizations to make it bareable.


Despite all this, it's usable and quite fun to work with.
