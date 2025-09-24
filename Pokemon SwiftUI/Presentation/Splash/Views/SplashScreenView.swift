//
//  SplashScreenView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var backgroundOpacity: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showLoadingText = false
    @State private var loadingDots = ""
    @Binding var showSplash: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    PokemonTheme.primaryBlue.opacity(0.8),
                    PokemonTheme.secondaryBlue,
                    PokemonTheme.primaryBlue.opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(backgroundOpacity)

            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...80))
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: CGFloat.random(in: 100...700)
                    )
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .opacity(isAnimating ? 0.3 : 0.1)
                    .animation(
                        .easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: isAnimating
                    )
            }

            VStack(spacing: 40) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(pulseScale)
                        .opacity(logoOpacity * 0.6)

                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)

                        Circle()
                            .fill(PokemonTheme.red)
                            .frame(width: 120, height: 120)
                            .clipShape(
                                Rectangle()
                                    .size(width: 120, height: 60)
                                    .offset(y: -30)
                            )

                        Rectangle()
                            .fill(PokemonTheme.textPrimary)
                            .frame(width: 120, height: 8)

                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(PokemonTheme.textPrimary, lineWidth: 4)
                            )

                        Circle()
                            .fill(PokemonTheme.primaryBlue)
                            .frame(width: 16, height: 16)
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                }

                VStack(spacing: 16) {
                    Text("POKEMON")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(logoOpacity)
                        .scaleEffect(logoScale * 0.8)
                }

                Spacer()

                if showLoadingText {
                    HStack(spacing: 8) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)

                        Text("Loading\(loadingDots)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .opacity(showLoadingText ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showLoadingText)
                }

                Spacer().frame(height: 60)
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.5)) {
            backgroundOpacity = 1.0
        }

        withAnimation(.spring(response: 1.0, dampingFraction: 0.6).delay(0.3)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        withAnimation(.easeInOut(duration: 0.8).delay(0.5)) {
            isAnimating = true
        }

        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(1.0)) {
            pulseScale = 1.1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showLoadingText = true
            }
            startLoadingAnimation()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            hideSplashScreen()
        }
    }

    private func startLoadingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if !showSplash {
                timer.invalidate()
                return
            }

            loadingDots = loadingDots.count < 3 ? loadingDots + "." : ""
        }
    }

    private func hideSplashScreen() {
        withAnimation(.easeOut(duration: 0.8)) {
            logoScale = 1.2
            logoOpacity = 0.0
            backgroundOpacity = 0.0
            showLoadingText = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            showSplash = false
        }
    }
}
