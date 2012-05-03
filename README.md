ImageMattingv2
==============
Reads in the image and the trimap and provides an alpha matte
and a foreground image. This is then composed onto a new
background image.

The algorithm does an excellent job of finding the edges in the
hair and creating the mask. Where it lacks is with the checkered
background. There are visual artifacts that remain in the final
image. They can be seen on the foreground and on the new 
background. However, it is most clear on the alpha matte. More
iterations clear up the results some.