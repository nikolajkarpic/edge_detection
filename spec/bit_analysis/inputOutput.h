#ifndef INPUTOUTPUT_H_INCLUDED
#define INPUTOUTPUT_H_INCLUDED

#include "common.h"



image2D loadImage(std::string path);
SCimage2D SCloadImage(std::string path);

void showImage(std::string path, image2D source);

void SCshowImage(std::string path, SCimage2D source);


#endif INPUTOUTPUT_H_INCLUDED