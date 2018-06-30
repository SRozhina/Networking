import Foundation

let application = Application()
application.task1()
application.task2()
application.task3()
application.task4()

let applicationPromised = ApplicationPromised()
applicationPromised.task1()
applicationPromised.task2()
applicationPromised.task3()
applicationPromised.task4()

RunLoop.main.run()
