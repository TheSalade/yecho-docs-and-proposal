# Yecho 
Yecho: DeFi yield tracking. Architecture &amp; docs only. Codebase is proprietary and private.

## Overview
Yecho is a DeFi yield tracking tool designed to automatically calculate and optimize users' yields across their DeFi positions, with a focus on integrating with the Optimism network. This repository contains documentation for a grant application.

## Problem Statement
DeFi users lack a unified, automated platform to track yields, requiring manual effort to monitor performance across protocols.

## How Yecho Works

1. **Connect Your Wallet**  
   Link any EVM-compatible wallet. A "burner" wallet works track another address from your dashboard.

2. **Free Beta Subscription**  
   Beta subscriptions are free. Post-beta, choose flexible plans (1 month, 3 months, or 1 year).

3. **Daily Snapshots**  
   Yecho automatically detects DeFi positions and takes daily snapshots at 5:00 PM EDT. Yields are calculated without user action.

4. **Subscription Management**  
   When a plan expires, snapshots pause, but historical data remains safe. No auto-renew—buy 1mo, 3mo, or 1yr to stack periods flexibly.

5. **Analyze & Optimize**  
   Dive into interactive charts to spot trends and maximize earnings.

6. **Multi-Protocol Support**  
   Tracks protocols like Aave, Compound, Spark, VenusProtocol, Fluid, YieldFi, Hyperlend, Felixprotocol, with more coming across multiple blockchains.

## Key Features
- Automatic DeFi position detection.
- Daily yield snapshots with historical data preservation.
- Interactive analytics for yield trends.
- Multi-chain and multi-protocol compatibility.

## Technical Details
- **Snapshot Process**: Executed daily at 5:00 PM EDT, ensuring consistent data capture.
- **Redundancy**: Uses multiple RPC providers to guarantee snapshot reliability if one fails.
- **Optimization**: Employs multicallV3 contracts to minimize RPC calls, maximizing efficiency during snapshots.

## Architecture Overview
<img width="1252" height="732" alt="yecho-architecture" src="https://github.com/user-attachments/assets/c6ee4d1e-d593-4d0b-87a8-269a367a13e8" />

- **Frontend**: React-based UI for yield visualization.
- **Backend**: Server layer for data processing.
- **Data Layer**: Storage for historical yield data.

## Supported Protocols

Yecho tracks **realized yields** from over **25+ DeFi protocols** across **10+ blockchains**(BNB Chain, Ethereum, Arbitrum, Base, Optimism ...), including lending, yield aggregators, and liquid staking.

Below is the full list of **supported protocols**, with **supported tokens per chain**.

---

### Lending Protocols

| Protocol       | Ethereum | Base | Arbitrum | Optimism | BNB Chain | Polygon | Avalanche | Plasma | Gnosis | Linea | Ink | Celo | Unichain | Katana | HyperEVM | TAC |
|----------------|---------|------|----------|----------|-----------|---------|-----------|--------|--------|-------|-----|------|----------|--------|----------|-----|
| **Aave**       | USDC, USDT, ETH, USDe, EURC, WBTC, DAI, GHO, PYUSD, weETH, wstETH, cbBTC, rsETH, RLUSD, osETH, LINK, LBTC, tBTC, rETH, USDtb, FBTC, ETHx, cbETH, LUSD | USDC, ETH, EURC, GHO, cbBTC, USDbC, weETH, wstETH, cbETH | USDC, USDT0, ETH, DAI, GHO, WBTC, USDC.e, weETH, wstETH, LINK, ARB, rETH | USDC, USDT, ETH, DAI, WBTC, USDC.e, wstETH, rETH, LINK | USDC, USDT, ETH, WBNB, WBTC, wstETH | USDC, USDT, USDC.e, DAI, WETH, WBTC, wstETH, POL, LINK | USDC, USDT, DAI, WBTC, WETH, AVAX, GHO, LINK, EURC | USDT0, USDe, WETH, weETH | wstETH, EURe, WETH, GNO, USDC.e, USDC, GHO, xDAI | USDC, USDT, WETH, WBTC, wstETH | WETH, USDT0, kBTC, GHO | USDT, WETH, CELO, USDC | — | — | — | — |
| **Fluid**      | USDC, USDT, ETH, GHO, sUSDS, wstETH, USDtb | USDC, ETH, EURC, GHO, sUSDS, wstETH | USDC, USDT, ETH, GHO, sUSDS, wstETH | — | — | USDC, USDT, ETH, wstETH | — | USDT0, USDe, WETH | — | — | — | — | — | — | — | — |
| **Spark**      | USDC, USDS, USDT, DAI, WETH, PYUSD, wstETH, cbBTC, rETH, WBTC, tBTC, stUSDS | USDC, USDS | USDC, USDS | USDC, USDS | — | — | — | — | — | — | — | — | USDC, USDS | — | — | — |
| **Compound**   | USDC, USDT, ETH, USDS, WBTC, wstETH | USDC, ETH, USDbC, USDS | USDC, USDT, USDC.e, ETH | USDC, USDT, ETH | — | USDC.e, USDT | — | — | — | USDC, WETH | — | — | USDC, WETH | — | — | — |
| **Morpho**     | USDC, USDT, WETH, DAI | USDC, USDT, WETH, cbBTC | USDC | USDC | — | USDC, USDT, USDT0, WETH | — | — | — | — | — | — | USDC, USDT0, WETH | USDC, USDT, WBTC | USDT0, rUSDC, WHYPE, ETH, USDe | — |
| **Euler**      | USDC, USDT, WETH, cbBTC, USDe, RLUSD, rsETH, weETH, wstETH | USDC, cbBTC, WETH | USDC, USDT0, WETH, WBTC, wstETH | — | WBNB, USDT, USD1 | — | USDC, USDT, WETH, BTC, AVAX, stAVAX | USDT0 | — | USDC, USDT, WETH, wstETH, weETH | — | — | USDC, USDT0, WETH, weETH | — | — | USDT |
| **Venus**      | USDC, USDT, WETH, WBTC, sUSDS, TUSD | USDC, ETH | USDC, USDT0, ETH | USDC, USDT, ETH | USDC, USDT, BNB, WBNB, asBNB, solvBTC, ETH, WBTC | USDC, WETH | — | — | — | — | — | — | USDC, WETH | — | — | — |

---

### Yield Aggregators

| Protocol         | Ethereum | Base | Arbitrum | Optimism | BNB Chain | Polygon | Avalanche | Plasma | Katana | Unichain | Plume | TAC | HyperEVM |
|------------------|---------|------|----------|----------|-----------|---------|-----------|--------|--------|----------|-------|-----|----------|
| **Yearn**        | USDC, USDS, DAI, USDT, WETH | USDC, WETH, cbBTC | USDC, USDT | — | — | USDC, USDT, USDC.e, DAI, WETH | — | — | USDC, ETH, USDT, WBTC | — | — | — | — |
| **YieldFi**      | USDC, WBTC, WETH | USDC, WETH | USDC, WETH | USDC | USDT | — | USDC | USDT | USDC | — | pUSD | USDT | — |
| **Avantis**      | — | USDC | — | — | — | — | — | — | — | — | — | — | — |
| **Yo Protocol**  | — | USDC, WETH, cbBTC, EURC | — | — | — | — | — | — | — | — | — | — | — |
| **40Acres**      | — | USDC | — | USDC | — | — | USDC | — | — | — | — | — | — |
| **Superlend**    | — | USDC | — | — | — | — | — | — | USDC, USDT, WETH, WBTC | — | — | — | — |
| **Ipor**         | rUSD, USDC, USDT, WETH, WBTC, USDe, DAI | USDC, wstETH, WETH, cbBTC | USDC | — | — | — | — | — | — | WETH | — | — | — |
| **Angle**        | USDA, EURA, USDC, USDT, DAI, EURC | USDA, USDC, USDT, USDS, EURA, EURC | USDA, EURA, USDC, USDT, DAI, USDS | USDA, USDC, USDT | — | — | — | — | — | — | — | — | — |
| **Cian**         | USDC, ETH, WETH, wBETH, rsETH, ETHx, stETH, wstETH, ezETH, FBTC, BBTC, uniBTC, WBTC, pumpBTC, SolvBTC, STONEBTC, LBTC, xSolvBTC, USDS, USDT, DAI, USCC | wstETH | rsETH, wstETH, weETH, ETHx | wstETH | wBETH, USD1, USDT, BTCB, slisBNB, BNB | — | — | — | — | — | — | — | — |
| **Almanak**      | USDC, USDT | — | — | — | — | — | — | — | — | — | — | — | — |

---

### Liquid Staking & Specialized Protocols

| Protocol         | Ethereum | Base | Arbitrum | HyperEVM | Avalanche |
|------------------|---------|------|----------|----------|-----------|
| **Lido**         | stETH, wstETH, GG, DVstETH | — | — | — | — |
| **Origin**       | OGN, OETH, OUSD, stETHARM | superOETH | wOETH | — | — |
| **Maple**        | USDC, USDT | — | — | — | — |
| **HyperLend**    | — | — | — | HYPE, BTC, ETH, USDe, USDT0, USDHL, USDC | — |
| **Felix**        | — | — | — | HYPE, USDe, USDT0, USDHL, USDC, USDH | — |
| **Hyperbeat**    | — | — | — | USDT0, USDC, WHYPE, XAUt, beHYPE, BTC | — |
| **Avant**        | savETH, avETHx | — | — | — | savUSD, savBTC, avUSDx, avBTCx |

---

> **Note**: Only **lending vaults** are tracked for **Morpho, Euler, Fluid, Ipor, 40Acres**.  
> **Cian**: Only **Yield Layer / Strategy Vaults**.  
> **All data is read on-chain** — no APY estimation. Yecho computes **realized daily income** via 24h snapshots.

---

**Want a protocol added?**  
[Request it here →](/contact)

---

## Development Status
A functional prototype is under active development in a private repository. This public repo is for proposal and documentation purposes only.

## Grant Purpose
Funding will support full development, integration testing, and marketing to build a user community.

## IP Disclaimer
This repository contains only documentation and a high-level architecture. The operational Yecho codebase is proprietary and not included. Forking does not grant rights to the project.
