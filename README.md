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

---

## Development Status
A functional prototype is under active development in a private repository. This public repo is for proposal and documentation purposes only.

## Grant Purpose
Funding will support full development, integration testing, and marketing to build a user community.

## IP Disclaimer
This repository contains only documentation and a high-level architecture. The operational Yecho codebase is proprietary and not included. Forking does not grant rights to the project.
