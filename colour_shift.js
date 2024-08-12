TestColour(0xff0132);
TestColour(0x00eeff);
TestColour(0x0011d1);
TestColour(0x7f3fc4);
TestColour(0x803fc4);

/**
 *
 * @param {number} colour
 */
function TestColour(colour) {
    let adjusted = ShiftColourUp(colour);

    console.log(`${colour.toString(16)} -> ${adjusted.toString(16)}`);
}

/**
 * Shifts colour by 2x.
 * @param { number } c 0x00ffffff where the last bits are the colours rbg
 * @returns { number } adjusted colour
 */
function ShiftColourUp(c) {
    // This has a 1 bit in every top most value for each individual colour code.
    let t1 = c & 0x00808080;
    c &= 0x007f7f7f; // opposite of above

    // Do right shift to decrease colour.
    c <<= 1;

    // We want to clone the 1s bit
    let t2 = t1 >> 1;
    t1 = t1 | t2;

    t2 = t1 >> 2;
    t1 = t2 | t1;

    t2 = t1 >> 4;
    t1 = t2 | t1;

    c |= t1;
    return c;
}
