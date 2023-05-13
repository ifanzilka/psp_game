#include <gfx.h>
#include <pspge.h>
#include <pspdisplay.h>

uint32_t* draw_buffer;
uint32_t* display_buffer;


namespace GFX
{
    void    init()
    {
        draw_buffer = sceGeEdramGetAddr();
        display_buffer = sceGeEdramGetAddr() + (272 * 512 * sizeof(uint32_t)) ;
    }

    void    clear(uint32_t color)
    {

    }

    
    void    swapBuffers()
    {

    }

    void    drawRect(int x, int y, int w, int h, uint32_t color)
    {

    }

}