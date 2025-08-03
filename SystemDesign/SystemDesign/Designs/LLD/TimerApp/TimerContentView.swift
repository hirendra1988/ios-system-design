//
//  TimerContentView.swift
//  SystemDesign
//
//  Created by Hirendra Sharma on 19/07/25.
//

import SwiftUI

struct TimerContentView: View {
    
    @StateObject private var viewModel = TimerViewModel(startSeconds: 8)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Time Remaining: \(viewModel.timeRemaining)")
            
            Button("Start") {
                viewModel.start()
            }
            
            Button("Stop") {
                viewModel.stop()
            }
            
            Button("Reset") {
                viewModel.reset()
            }
        }
    }
}

#Preview {
    TimerContentView()
}
