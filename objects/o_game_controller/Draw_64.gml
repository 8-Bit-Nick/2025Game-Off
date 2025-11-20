// Cursor Pop-ups
// Render each popup in GUI space
for (var i = 0; i < array_length(popups); i++) {
    var p = popups[i];

    // shadow for readability
    draw_set_alpha(p.alpha);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);
    draw_text(p.x + 1, p.y + 1, p.text);

    // main colored text
    draw_set_color(p.col);
    draw_text(p.x, p.y, p.text);

    draw_set_alpha(1);
}
