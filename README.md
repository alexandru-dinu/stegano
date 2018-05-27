# Stegano
Audio Steganography project for Signal Processing class

For this project, two main methods of concealing a secret in a carrier data were implemented:

 - image-in-audio
 - text-in-image

Image-in-audio is implemented using a basic LSB encoding and it is used to demonstrate the ease of embedding a grayscale image into an audio file, without any perceptible differences when replaying the altered audio track.

Text-in-image is implemented using a slightly modified algorithm presented in a paper (see doc/). This method uses the 2D Discrete Wavelet Transform (DWT) on the Cb channel of a YCbCr image to delimit regions of detail and then embeds the text into those regions that are imperceptible to the human eye.
