import Dispatch

print("Start...")

let workItem = DispatchWorkItem {
    print("❌ This will not be executed, 🤖 is sad.")
}

DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)

workItem.cancel()

print("Oops!")
