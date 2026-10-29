//
//  Achievement.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 22/10/26.
//

import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let systemImageName: String 
    var isUnlocked: Bool

    static func defaultAchievements(unlockedIds: [String]) -> [Achievement] {
        let all: [(id: String, title: String, desc: String, icon: String)] = [
            ("first_blitz", "First Blood", "Complete your first Arena quiz", "bolt.fill"),
            ("streak_3", "Hot Streak", "Maintain a 3-day practice streak", "flame.fill"),
            ("pupil_rank", "Rising Star", "Achieve Pupil rank (1400+ Elo)", "star.fill"),
            ("specialist_rank", "Specialist", "Achieve Specialist rank (1600+ Elo)", "shield.checkerboard"),
            ("perfect_score", "Flawless Logic", "Score 5/5 in any quiz round", "crown.fill"),
            ("tree_master", "Graph Master", "Conquer the Trees & Graphs arena", "network")
        ]
        
        return all.map { item in
            Achievement(
                id: item.id,
                title: item.title,
                description: item.desc,
                systemImageName: item.icon,
                isUnlocked: unlockedIds.contains(item.id)
            )
        }
    }
}
