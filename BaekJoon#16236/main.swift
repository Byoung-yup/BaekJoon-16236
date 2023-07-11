//
//  main.swift
//  BaekJoon#16236
//
//  Created by 김병엽 on 2023/06/13.
//
// Reference: https://velog.io/@aurora_97/백준-16236번-아기-상어-Swift


let n = Int(readLine()!)!
var graph = [[Int]]()

var shark = (-1, -1, -1)
var eatCnt = 0

for i in 0..<n {
    let t = readLine()!.split(separator: " ").map { Int(String($0))! }
    graph.append(t)
    
    // 값이 9인 배열의 인덱스 구하기.
    if let j = t.firstIndex(of: 9) {
        shark = (i, j, 2) // 아기 상어 위치값.
        graph[i][j] = 0 // 아기 상어 위치.
    }
}

var time = 0

func bfs() -> Bool {
    
    var queue = [(shark.0, shark.1, 0)]
    var idx = 0
    
    let dx = [1, -1, 0, 0]
    let dy = [0, 0, 1, -1]
    
    var visit = Array(repeating: Array(repeating: false, count: n), count: n)
    visit[shark.0][shark.1] = true
    
    var dist = Int.max
    var fishList = [(Int, Int)]()
    
    while queue.count > idx {
        
        let (x,y,cnt) = queue[idx]
        idx += 1
        
        if cnt > dist { continue }
        
        if (1..<shark.2).contains(graph[x][y]) {
            dist = cnt
            fishList.append((x,y))
        }
        
        for i in 0..<4 {
            let (nx,ny) = (x + dx[i], y + dy[i])
            
            if (0..<n).contains(nx) && (0..<n).contains(ny) && !visit[nx][ny] && graph[nx][ny] <= shark.2 {
                visit[nx][ny] = true
                queue.append((nx, ny, cnt + 1))
            }
        }
    }
    
    if fishList.isEmpty {
        return false
    }
    
    // 아기 상어가 이동할 수 있는 규칙대로 fishlist를 정렬.
    fishList.sort {
        if $0.0 == $1.0 {
            return $0.1 < $1.1
        }
        return $0.0 < $1.0
    }
    
    // 먹고 카운트 증가.
    let target = fishList.first!
    eatCnt += 1
    
    // 먹은 갯수와 크기가 동일하면, 상어의 크기 증가.
    if eatCnt == shark.2 {
        shark.2 += 1
        eatCnt = 0
    }
    
    graph[target.0][target.1] = 0 // 먹은 자리는 0으로 초기화.
    shark = (target.0, target.1, shark.2) // 아기 상어 값 초기화.
    
    time += dist // 이동한 거리만큼 시간 증가.
    return true
    
}

while true {
    if !bfs() {
        print(time)
        break
    }
}
