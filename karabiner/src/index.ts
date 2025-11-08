import {
    rule,
    layer,
    map,
    toKey,
    toStickyModifier,
    ifDevice,
    writeToProfile,
} from "karabiner.ts";
import { hrm, capsWord } from "karabiner.ts-greg-mods";

const l = (key: any): any => `l${key}`;
const r = (key: any): any => `r${key}`;

const ctrl = "⌃";
const alt = "⌥";
const gui = "⌘";
const caps = "⇪";

writeToProfile("Default profile", [
    rule("Home row mods").manipulators(
        hrm(
            new Map([
                ["d", l(ctrl)],
                ["s", l(alt)],
                ["f", l(gui)],
                ["j", r(gui)],
                ["k", r(ctrl)],
                ["l", r(alt)],
            ]),
        )
            .tappingTerm(150)
            .build(),
    ),
    capsWord().toggle(map("grave_accent_and_tilde").build()[0]).build(),
    rule("some remaps").manipulators([
        map("⇪", "optionalAny").to("escape"),
        map("p", "optionalAny").to("'"),
        map("'", "optionalAny").to("return_or_enter"),
    ]),
    layer(r(gui), "cag-arrow-mode")
        .modifiers("optionalAny")
        .configKey(
            (v) =>
                v.toIfAlone([
                    toStickyModifier("right_command"),
                    toStickyModifier("right_control"),
                    toStickyModifier("right_option"),
                ]),
            true,
        )
        .manipulators({
            u: toKey("page_down"),
            i: toKey("page_up"),
            h: toKey("left_arrow"),
            j: toKey("down_arrow"),
            k: toKey("up_arrow"),
            l: toKey("right_arrow"),
            f: toKey(l(gui)),
            d: toKey(l(ctrl)),
            s: toKey(l(alt)),
            m: toKey("delete_or_backspace"),
        }),
    layer(l(gui), "shift-symbol-mode")
        .modifiers("optionalAny")
        .configKey((v) => v.toIfAlone([toStickyModifier("left_shift")]), true)
        .manipulators({
            // left
            g: toKey("5", "left_shift"),
            r: toKey("6", "left_shift"),
            f: toKey("="),
            v: toKey("7", "left_shift"),
            e: toKey("8", "left_shift"),
            d: toKey("=", "left_shift"),
            c: toKey("backslash", "left_shift"),
            w: toKey("grave_accent_and_tilde", "left_shift"),
            s: toKey("-"),
            a: toKey("1", "left_shift"),
            // right
            y: toKey("3", "left_shift"),
            h: toKey("p"),
            n: toKey("p", "left_shift"),
            u: toKey("4", "left_shift"),
            j: toKey("9", "left_shift"),
            m: toKey("[", "left_shift"),
            i: toKey("2", "left_shift"),
            k: toKey("0", "left_shift"),
            ",": toKey("]", "left_shift"),
            l: toKey("["),
            ".": toKey("]"),
            p: toKey("grave_accent_and_tilde"),
            "'": toKey("grave_accent_and_tilde"),
            ";": toKey("-", "left_shift"),
            "/": toKey("backslash"), 
        }),
    layer("spacebar", "numbers-mode")
        .modifiers("optionalAny")
        .manipulators({
            j: toKey(1),
            k: toKey(3),
            l: toKey(5),
            ";": toKey(7),
            m: toKey(9),

            f: toKey(0),
            d: toKey(2),
            s: toKey(4),
            a: toKey(6),
            v: toKey(8),
        }),
]);
