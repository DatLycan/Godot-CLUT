
# CLUT (Color Lookup Texture)

Dynamic pixel art skin texture shader.
> Only compatible with **Godot 4.x**.
> Heavily inspired by [aarthificial](https://github.com/aarthificial)'s "[Pixel Art Animation. Reinvented](https://youtu.be/HsOKwUwL1bE)" video.

## Features

- Apply skin textures to pixel art textures.
- Dynamically generate base textures for CLUT shader.

## Installation

1. Download this repository.

2. Move the ``addons/CLUT`` folder to the ``addons`` folder of your Godot project.

3. Enable the plugin in your project by going to ``Project Settings`` > ``Plugins`` and activate ``CLUT Base Generator``.

## Usage

1. Add a `Sprite2D` or `AnimatedSprite2D` node to your scene.

2. Create a `map` and `source` texture in your preferred graphics software.

3. Place both files in the same subfolder of `res://`.

4. Add the `.map` and `.source` extensions to the filenames accordingly.

5. Add the newly generated `.base` texture as the node's texture.

6. Apply the CLUT shader (`addons/CLUT/Shader/CLUT.gdshader`) to the node's material.

7. Create a skin texture that's based on the `map`'s pixel coordinates.

8. Add the skin texture to the CLUT shader's parameters.

> You can edit the file suffixes in the Editor Settings. Go to ``Editor Settings`` > ``FileSystem/Clut``.

## Note

I highly advise you to watch [aarthificial](https://github.com/aarthificial)'s "[Pixel Art Animation. Reinvented](https://youtu.be/HsOKwUwL1bE)" video to fully understand this system.

## License

This plugin is released under the [MIT License](https://github.com/DatLycan/CLUT/blob/main/LICENSE).
