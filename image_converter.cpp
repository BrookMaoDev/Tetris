/*
This is a bit hard to configure. You need ImageMagick installed.

g++ `Magick++-config --cxxflags --cppflags` -O2 image_converter.cpp `Magick++-config --ldflags --libs`
*/
#include <Magick++.h>
#include <iostream>
#include <string>
#include <filesystem>

const std::string image_path = "./images/";

inline bool ends_with(const std::string &str, const std::string &end)
{
  if (end.size() > str.size())
  {
    return false;
  }

  return std::equal(end.rbegin(), end.rend(), str.rbegin());
}

const char hex_digits[] = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

std::string convert_to_hex(unsigned int val, int padding)
{
  std::string result = "";

  while (val > 0)
  {
    result += hex_digits[val % 16];
    val >>= 4;
  }

  for (int i = result.size(); i < padding; i++)
  {
    result += '0';
  }

  for (int i = 0; i < result.size() / 2; i++)
  {
    char temp = result[i];
    result[i] = result[result.size() - 1 - i];
    result[result.size() - 1 - i] = temp;
  }

  return result;
}

int main()
{
  Magick::InitializeMagick(nullptr);

  std::filesystem::directory_iterator dir_iter = std::filesystem::directory_iterator(image_path);

  Magick::Image image;

  for (const auto &file : dir_iter)
  {
    if (file.is_directory())
    {
      continue;
    }

    const std::string file_path = file.path().string();

    if (!ends_with(file_path, "png"))
    {
      continue;
    }

    // Process the image file.
    image.read(file_path);

    auto pixels = image.getPixels(0, 0, image.columns(), image.rows());

    // Amount to shift the current pixel.
    int bit_shift = 0;
    unsigned int word = 0;
    // Print width/height of image.
    std::cout << "Image: " << file_path << "\n";
    std::cout << "character: .word 0x";

    std::cout << convert_to_hex(
                     image.columns() + (image.rows() << 16), 8)
              << ", 0x";

    // Start the actual image making.
    for (int r = 0; r < image.rows(); r++)
    {
      for (int c = 0; c < image.columns(); c++)
      {
        Magick::PixelPacket px = *pixels;

        word += (px.blue != 0 || px.green != 0 || px.red != 0) << bit_shift;
        bit_shift++;
        // std::cout << px.red << " " << px.green << " " << px.blue << " " << (px.blue != 0 || px.green != 0 || px.red != 0) << " " << word <<"\n";

        if (bit_shift >= 32)
        {
          std::cout << convert_to_hex(word, 8) << ", 0x";
          bit_shift = 0;
          word = 0;
        }

        pixels++;
      }
    }

    std::cout << convert_to_hex(word, 8) << "\n";
  }

  return 0;
}
