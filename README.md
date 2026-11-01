# Feels Local

A playful, unofficial playground for wireless GPUs, built around WiCi One and InferSSD.

- **Play:** be the protocol. Switch on four tricks and watch one Qwen-VL-8B answer drop from about 160 s to about 4.5 s over Wi-Fi, using WiCi's formula `T = T_local + N × RTT + D ÷ rate`.
- **Three doors:** the driver, the SDK and the API, with code you can copy.
- **800B on a laptop:** a download and disk planner for InferSSD, plus a pre-flight script.

One static page, no build step. Open `index.html` in a browser to run it locally.

## Deploy on GitHub Pages

1. Push this folder to a repo (for example `feels-local`).
2. In the repo, go to **Settings → Pages**.
3. Under **Source**, pick **Deploy from a branch**, then `main` and `/ (root)`. Save.
4. The site goes live at `https://<your-username>.github.io/feels-local/` in a minute or two.

## Notes

Not affiliated with or endorsed by WiCi. Figures come from WiCi's public pages and the InferSSD repo as of November 1, 2026. How the 10x call reduction splits across the tricks, and the 16 GB weight upload, are illustrations, not benchmarks.

Made by [Aliasgar Merchant](https://ali-the-curios.dev).
