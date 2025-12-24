# Music Player

A simple, static, multi-page Music Player website to browse artists, albums, and your library. Built with HTML and CSS — no build steps or dependencies required.

## Features
- Multi-page layout: Home, Library, Artists, and Albums
- Clean styling via `style.css`
- Lightweight and fast: pure HTML/CSS
- Easy to extend with more artists, albums, and images

## Pages
- `index.html`: Home / landing page
- `Library.html`: Your music collection view
- `Artist.html`: Artists listing and details
- `Album.html`: Albums listing and details

## Quick Start
You can open the site directly in your browser or serve it locally.

### Option 1: Open directly
- On Windows, double-click `index.html` or right-click → Open with → your browser.

### Option 2: Local server (optional)
If you have Python installed, you can serve the folder:

```powershell
# In the project root
python -m http.server 8080
# Open in your browser
Start-Process http://localhost:8080
```

Alternatively, use VS Code’s Live Server extension to serve the site with hot-reload.

## Project Structure
```
MUSIC PLAYER/
├─ index.html
├─ Library.html
├─ Artist.html
├─ Album.html
├─ style.css
└─ img/
   ├─ A.R. Rahman.jpg
   ├─ Ed-Sheeran.jpeg
   ├─ Harry Styles.jpg
   └─ ORDINARY COVER.jpg
```

## Customization
- Update styles in `style.css` to change the theme and layout.
- Add or replace images in `img/` and reference them from your HTML pages.
- Extend `Artist.html` and `Album.html` with more entries as needed.
- Keep image filenames web-friendly (avoid spaces if possible) and use consistent formats (e.g., `.jpg` or `.png`).

## Screenshots (optional)
Add screenshots to `img/` and embed them here in Markdown:

```md
![Home](img/your-screenshot-home.png)
![Library](img/your-screenshot-library.png)
```

## Development Notes
- No build tools required. Edit HTML/CSS files directly.
- Consider organizing content data (artists/albums) with simple sections or cards for consistency.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
Specify a license for your project (e.g., MIT) if you plan to share or open source it.
