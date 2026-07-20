import type { Metadata } from "next";
import { Bricolage_Grotesque, DM_Sans } from "next/font/google";
import "./globals.css";

const bricolage = Bricolage_Grotesque({
  variable: "--font-bricolage",
  subsets: ["latin"],
  weight: ["700", "800"],
});

const dmSans = DM_Sans({
  variable: "--font-dm-sans",
  subsets: ["latin"],
  weight: ["400", "500", "700"],
});

export const metadata: Metadata = {
  title: "ClearSwap | Zero-Trust Escrow Terminal",
  description: "ClearSwap is a bold, zero-trust P2P escrow terminal that locks funds and releases them natively using FaceID and Apple Wallet.",
  icons: {
    icon: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="%230F1720" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12c4-8 4-8 8 0s4 8 8 0"/></svg>'
  }
};

import { SimulatorProvider } from "@/components/providers/SimulatorProvider";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${bricolage.variable} ${dmSans.variable} font-sans antialiased bg-[#f5efe2] text-[#17140d] overflow-x-hidden`}
      >
        <SimulatorProvider>
          {children}
        </SimulatorProvider>
      </body>
    </html>
  );
}
