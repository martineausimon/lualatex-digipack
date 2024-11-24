# lualatex-digipack

This repository provides a modular template for creating a **Digipack album cover** using [LuaLaTeX](https://www.luatex.org/). The template is customizable and can be adapted for different design needs. It was created using the [standard digipack template](https://x-disc.pl/wp-content/uploads/2023/05/D01-DigipackCD4p-6mm.pdf) available at [x-disc.pl](https://x-disc.pl/).

- [Requirements](#requirements)
- [Features](#features)
- [Setup and Usage](#setup-and-usage)
  - [Download Required Fonts](#download-required-fonts)
  - [Editing the Content](#editing-the-content)
    - [cover.tex](#cover.tex)
    - [disc.tex](#disc.tex)
  - [Customizing the Template](#customizing-the-template)
  - [Compile the Template](#compile-the-template)
    - [Compiling the Files](#compiling-the-files)
    - [Color Profile](#color-profile)
  - [Convert Fonts into Lines](#convert-fonts-into-lines)
- [Contributing](#contributing)

<p align="center">
    <img src="https://github.com/user-attachments/assets/d9648eb6-d4e9-4321-a45c-4d8faf782708">
</p>

<p align="center">
    <img src="https://github.com/user-attachments/assets/d4f3c7c4-c65b-40e7-b14b-5e7b5273be39">
</p>

## REQUIREMENTS

To use this template, ensure you have the following installed on your system :

* `LuaLaTeX` (used to compile .tex files).
* `Lua` (required for the utility scripts in the tools/ folder).
* `ImageMagick` (for image processing tasks).
* `Ghostscript` (for converting embedded fonts to vector outlines).
* `wget` and `unzip` (required to fetch fonts and ICC profiles).

## FEATURES

* **Modular Structure** : The template consists of multiple LaTeX files for flexibility and easy customization.
* **Barcode Generation** : Integrates barcode creation for your album from the barcode number.
* **Tracklist and Artist Information** : Automatic formatting for tracklists and artist details.
* **Bleed and Cutting Lines** : Defined lines for print production, ensuring correct trimming and alignment.
* **Color Profile Conversion** : RGB to CMYK conversion for high-quality print output (via the `./tools/rgb2cmyk` script).
* **Font Outline Conversion**: Converts embedded fonts into vector outlines for PDFs (via the `./tootls/fonts2lines` script).

## SETUP AND USAGE

### Download required fonts

The **Compact Disc** logo used in the template is **hardcoded** and requires specific fonts that are not included by default. To download these fonts, run the following Lua script to fetch them and save them in the `./fonts/` directory:

```bash
./tools/download-fonts
```

This script will download the necessary font files:

* Disc font: Used for the "disc" text in the logo.
* Eurostile Bold: Used for the "DIGITAL AUDIO" text in the logo.

### Editing the Content

**Main Input Files** : `cover.tex` and `disc.tex`

The primary content of the digipack design is defined in the following files :

#### `cover.tex`

This file is used to specify the details of the album's cover, including :

* The album title.
* Tracklist (using the `\newTrack` command).
* Artist lineup (using the `\newArtist` command).
* Additional graphic elements such as barcodes or custom decorations.

Example :

```tex
\newTrack{Track Title}{Duration}
\newArtist{Artist Name}{Instrument}
```

#### `disc.tex`

This file is dedicated to the design of the CD label, such as:

* Text placement (e.g., album name, artist, release year).
* Compact Disc logo.
* Legal phrase.

### Customizing the Template

Modify the LaTeX files to adjust the layout, design, and content for your album cover:

* `lib/cover.tex` : The main layout for the album cover, including the folding lines and cutting marks.
* `lib/disc.tex` : The layout for the disc label, with customizable logo placement.
* `lib/global.tex` : Global settings such as fonts, color definitions, and reusable commands.

### Compile the Template

Once you've customized your template, compile it using LuaLaTeX :

```bash
lualatex cover.tex
lualatex disc.tex
```

You can remove the cut lines and safety margins by commenting out or deleting the `\showframes` command located at the end of the `cover.tex` and `disc.tex` documents.

>[!Important]
>
> #### COMPILING THE FILES
>
>Each `.tex` file must be compiled twice with `lualatex`. This is necessary because the layout heavily relies on TikZ, specifically its `remember picture` and overlay options.
>
>When using remember picture, TikZ processes require precise coordinates from previous pages or layers, which are only available after the first pass of compilation. The second pass ensures that all elements are correctly aligned and rendered at their intended positions.
>
>**Without the second compilation, you may encounter issues like misaligned graphics, incorrect text placement, or missing elements in the overlay.**
>
> #### COLOR PROFILE
>
> Every image embedded in the PDF must use the CMYK color profile. You can use the provided script `tools/rgb2cmyk` to convert images or PDFs to the **ISOcoated_v2_300_FOGRA_39L** CMYK profile, which is optimized for professional printing and recommended by x-disc.pl.
> 
> To perform the conversion, run :
> 
> ```bash
> ./tools/rgb2cmyk [input_file]
> ```
> 
> * Supported input formats: PNG, JPG, and PDF.
> * The script automatically checks for the required ICC profile in the `./lib/` directory. If it is missing, the script will download it from the x-disc website.
> * The converted file will be saved in the same directory as the input, with `.cmyk` appended to the filename (e.g., `image.cmyk.jpg` or `document.cmyk.pdf`). **Note that the png format does not work with the CMYK profile, the output will be a jpg file**
>
> You can check if your `cover.pdf` or `disc.pdf` has the correct color profil using this command :
>
> ```bash
> magick identify -verbose [input_file] | grep "Colorspace"
> ```

### Convert fonts into lines

The script `./tools/fonts2lines` converts all embedded fonts in a PDF to vector outlines, ensuring print-ready files with no font embedding issues.

Usage :

```bash
./tools/fonts2lines input.pdf
```

## CONTRIBUTING

Feel free to fork this template and make modifications to suit your needs. Contributions, bug reports, and feature requests are welcome !


