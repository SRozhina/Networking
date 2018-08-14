import Foundation

let application = Application()

//Get all users
application.task1()
//Get post number 5 with user and comments
application.task2()
//Get all posts with user and comments
application.task3()
//Update user
application.task4()


let applicationPromised = ApplicationPromised()
applicationPromised.task1()
applicationPromised.task2()
applicationPromised.task3()
applicationPromised.task4()

RunLoop.main.run()
