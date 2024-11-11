import yaml
import io
import sys

colors_file = sys.argv[1]
config_css = open('colors.css', 'w')
config_kitty = open('kitty_colors.conf', 'w')
config_hypr = open('hypr_colors.conf', 'w')
config_rofi = open('rofi_colors.rasi', 'w')

with io.open(colors_file, 'r') as stream:
    with io.open('kitty.yaml', 'r') as kitty_stream:
        kitty_map = yaml.safe_load(kitty_stream)['colors']
        colors = yaml.safe_load(stream)['colors']

        def write_css(col, col_type, val):
            name = f'{col}' if col_type == 'extra' else f'{col}_{col_type}'
            config_css.write(f'@define-color {name} #{val};\n')

        def write_kitty(name, val):
            config_kitty.write(f'{name} #{val}\n')

        def write_hypr(col, col_type, val):
            name = f'{col}' if col_type == 'extra' else f'{col}_{col_type}'
            config_hypr.write(f'${name} = {val}\n')

        def write_rofi(col, col_type, val):
            col_type = col_type.replace('_', '-')
            col = col.replace('_', '-')
            name = f'{col}' if col_type == 'extra' else f'{col}-{col_type}'
            config_rofi.write(f'    {name}: #{val};\n')

        config_rofi.write('* {\n')
        for col_type in colors:
            for col in colors[col_type]:
                val = colors[col_type][col]
                write_css(col, col_type, val)
                write_hypr(col, col_type, val)
                write_rofi(col, col_type, val)
        config_rofi.write('}\n')

        for col_type in kitty_map:
            for col in kitty_map[col_type]:
                val = colors[col_type][col]
                name = kitty_map[col_type][col]
                write_kitty(name, val)
