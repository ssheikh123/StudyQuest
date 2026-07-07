import SwiftUI

enum CurriculumData {
    static let subjects: [Subject] = [
        Subject(
            id: "algebra",
            title: "Algebra",
            iconName: "x.squareroot",
            color: AppTheme.primary,
            lessons: [
                lesson("algebra-variables-expressions", "Variables & Expressions", "algebra", "Algebra", .beginner, 1, "x.squareroot", .blue, "Learn how letters can stand for numbers and how expressions describe math relationships.", "A variable is a symbol, often a letter, that represents a number. An expression combines numbers, variables, and operations but does not include an equals sign.", "If x = 4, then 3x + 2 becomes 3(4) + 2 = 14.", 35, 20, "5 min", [
                    question("What is a variable?", [answer("A symbol for an unknown or changing number", true), answer("A math sentence with an equals sign"), answer("Only the number zero")]),
                    question("Which is an expression?", [answer("2x + 5", true), answer("2x + 5 = 11"), answer("x is blue")]),
                    question("If n = 3, what is n + 7?", [answer("10", true), answer("21"), answer("4")])
                ]),
                lesson("algebra-solving-equations", "Solving Equations", "algebra", "Algebra", .beginner, 2, "equal.circle.fill", .blue, "Use inverse operations to find the value that makes an equation true.", "An equation says two expressions are equal. To solve it, keep both sides balanced while isolating the variable.", "x + 6 = 14. Subtract 6 from both sides: x = 8.", 40, 20, "6 min", [
                    question("What should you do to both sides of an equation?", [answer("Keep them balanced", true), answer("Change only the left side"), answer("Ignore the equals sign")]),
                    question("Solve x - 5 = 9.", [answer("14", true), answer("4"), answer("45")]),
                    question("What operation undoes multiplication?", [answer("Division", true), answer("Addition"), answer("Subtraction")])
                ]),
                lesson("algebra-graphing-lines", "Graphing Lines", "algebra", "Algebra", .beginner, 3, "chart.xyaxis.line", .blue, "Connect equations to points and lines on a coordinate plane.", "A linear equation can be graphed as a straight line. Ordered pairs show locations using x and y values.", "For y = x + 2, when x = 0, y = 2, so (0, 2) is on the line.", 45, 20, "7 min", [
                    question("What shape does a linear equation make?", [answer("A straight line", true), answer("A circle"), answer("A triangle")]),
                    question("In (3, 5), what is the x-value?", [answer("3", true), answer("5"), answer("8")]),
                    question("For y = x + 1, what is y when x = 4?", [answer("5", true), answer("4"), answer("1")])
                ]),
                lesson("algebra-factoring", "Factoring", "algebra", "Algebra", .beginner, 4, "square.grid.2x2.fill", .blue, "Break expressions into multiplied pieces to reveal their structure.", "Factoring rewrites an expression as a product. It is the reverse of distributing.", "6x + 9 has a common factor of 3, so it becomes 3(2x + 3).", 45, 20, "7 min", [
                    question("Factoring is the reverse of what?", [answer("Distributing", true), answer("Graphing"), answer("Estimating")]),
                    question("What common factor is in 4x + 8?", [answer("4", true), answer("8x"), answer("12")]),
                    question("Which equals 2(x + 3)?", [answer("2x + 6", true), answer("x + 5"), answer("2x + 3")])
                ]),
                lesson("algebra-quadratic-equations", "Quadratic Equations", "algebra", "Algebra", .beginner, 5, "function", .blue, "Meet equations with squared variables and curved graphs.", "A quadratic equation includes a variable raised to the second power. Its graph is a curve called a parabola.", "x^2 = 9 has two solutions because 3^2 = 9 and (-3)^2 = 9.", 50, 20, "8 min", [
                    question("What power appears in a quadratic equation?", [answer("2", true), answer("1"), answer("10")]),
                    question("What is the graph of a quadratic called?", [answer("Parabola", true), answer("Line"), answer("Ray")]),
                    question("Which number solves x^2 = 16?", [answer("4", true), answer("8"), answer("2")])
                ])
            ]
        ),
        Subject(
            id: "reading",
            title: "Reading",
            iconName: "book.fill",
            color: .orange,
            lessons: [
                lesson("reading-main-idea", "Main Idea", "reading", "Reading", .beginner, 1, "book.fill", .orange, "Find what a paragraph or passage is mostly about.", "The main idea is the central point. Details support it with facts, examples, or descriptions.", "If every sentence describes how bees help plants grow, the main idea is that bees are important pollinators.", 35, 20, "5 min", [
                    question("What is the main idea?", [answer("The central point", true), answer("A small detail"), answer("The final word")]),
                    question("What do details do?", [answer("Support the main idea", true), answer("Replace the title"), answer("Hide the topic")]),
                    question("Where can a main idea appear?", [answer("Anywhere in a passage", true), answer("Only the first word"), answer("Only in questions")])
                ]),
                lesson("reading-context-clues", "Context Clues", "reading", "Reading", .beginner, 2, "text.magnifyingglass", .orange, "Use nearby words to figure out unfamiliar vocabulary.", "Context clues are hints around a word. They may be examples, definitions, contrasts, or descriptions.", "The arid desert had almost no rain, so arid means very dry.", 40, 20, "6 min", [
                    question("What are context clues?", [answer("Hints near an unknown word", true), answer("Page numbers"), answer("Chapter titles only")]),
                    question("In 'frigid, or very cold,' what does frigid mean?", [answer("Very cold", true), answer("Very loud"), answer("Very fast")]),
                    question("Which can be a context clue?", [answer("A definition in the sentence", true), answer("A random guess"), answer("The book cover only")])
                ]),
                lesson("reading-inference", "Inference", "reading", "Reading", .beginner, 3, "lightbulb.fill", .orange, "Combine text evidence with what you know to understand unstated ideas.", "An inference is a smart conclusion. Readers infer when an author gives clues but does not say everything directly.", "If a character grabs an umbrella before leaving, you can infer it may rain.", 45, 20, "7 min", [
                    question("What is an inference?", [answer("A conclusion based on clues", true), answer("A copied sentence"), answer("A table of contents")]),
                    question("What should support an inference?", [answer("Text evidence", true), answer("Only a feeling"), answer("The page color")]),
                    question("If someone shivers and puts on a coat, what can you infer?", [answer("They feel cold", true), answer("They are cooking"), answer("They are swimming")])
                ]),
                lesson("reading-authors-purpose", "Author's Purpose", "reading", "Reading", .beginner, 4, "person.text.rectangle.fill", .orange, "Identify why an author wrote a text.", "Authors commonly write to inform, persuade, entertain, or explain. Clues in tone and details reveal the purpose.", "An article listing facts about volcanoes is likely written to inform.", 45, 20, "7 min", [
                    question("Which is a common author's purpose?", [answer("To inform", true), answer("To erase"), answer("To measure")]),
                    question("A funny story is often written to...", [answer("Entertain", true), answer("Calculate"), answer("Sort")]),
                    question("An ad asking you to buy something is meant to...", [answer("Persuade", true), answer("Sleep"), answer("Describe nothing")])
                ]),
                lesson("reading-comparing-texts", "Comparing Texts", "reading", "Reading", .beginner, 5, "rectangle.split.2x1.fill", .orange, "Notice how two texts are alike and different.", "Comparing texts means looking at their topics, details, structure, and point of view side by side.", "Two articles may both discuss oceans, but one focuses on animals while the other explains tides.", 50, 20, "8 min", [
                    question("What does comparing texts involve?", [answer("Finding similarities and differences", true), answer("Reading only the title"), answer("Skipping details")]),
                    question("Two texts can share a topic but have different...", [answer("Focuses", true), answer("Alphabets"), answer("Page edges")]),
                    question("Which helps compare texts?", [answer("A side-by-side chart", true), answer("Closing the book"), answer("Ignoring evidence")])
                ])
            ]
        ),
        Subject(
            id: "biology",
            title: "Biology",
            iconName: "leaf.fill",
            color: AppTheme.greenSuccess,
            lessons: [
                lesson("biology-cells", "Cells", "biology", "Biology", .beginner, 1, "circle.grid.cross.fill", .green, "Explore the tiny units that make up living things.", "Cells are the basic units of life. They contain parts that perform jobs, such as controlling activity or making energy.", "A cell membrane acts like a boundary, controlling what enters and leaves the cell.", 35, 20, "5 min", [
                    question("What are cells?", [answer("Basic units of life", true), answer("Types of rocks"), answer("Weather patterns")]),
                    question("What does a cell membrane do?", [answer("Controls what enters and leaves", true), answer("Makes sunlight"), answer("Stores books")]),
                    question("Living things are made of...", [answer("Cells", true), answer("Plastic"), answer("Clouds")])
                ]),
                lesson("biology-genetics", "Genetics", "biology", "Biology", .beginner, 2, "dna", .green, "Learn how traits are passed from parents to offspring.", "Genes are instructions carried in DNA. They influence traits such as eye color, plant height, or blood type.", "If a pea plant inherits genes for tall stems, it may grow taller than plants without those genes.", 40, 20, "6 min", [
                    question("What carries genetic instructions?", [answer("DNA", true), answer("Sand"), answer("Water vapor")]),
                    question("Genes influence...", [answer("Traits", true), answer("Calendar dates"), answer("Compass directions")]),
                    question("Traits can be passed from...", [answer("Parents to offspring", true), answer("Rocks to rivers"), answer("Books to pencils")])
                ]),
                lesson("biology-ecosystems", "Ecosystems", "biology", "Biology", .beginner, 3, "globe.americas.fill", .green, "See how organisms interact with each other and their environment.", "An ecosystem includes living organisms and nonliving parts like water, sunlight, soil, and air.", "In a pond ecosystem, fish, plants, water, sunlight, and insects all interact.", 45, 20, "7 min", [
                    question("What does an ecosystem include?", [answer("Living and nonliving parts", true), answer("Only animals"), answer("Only buildings")]),
                    question("Which is nonliving?", [answer("Sunlight", true), answer("Frog"), answer("Tree")]),
                    question("Organisms in ecosystems...", [answer("Interact", true), answer("Never affect each other"), answer("Are all identical")])
                ]),
                lesson("biology-human-body", "Human Body", "biology", "Biology", .beginner, 4, "figure.arms.open", .green, "Understand how body systems work together.", "The human body has systems for movement, digestion, circulation, breathing, and more. These systems depend on each other.", "The respiratory system brings in oxygen, and the circulatory system carries it through the body.", 45, 20, "7 min", [
                    question("Body systems usually work...", [answer("Together", true), answer("Completely alone"), answer("Only during sleep")]),
                    question("Which system moves oxygen through blood?", [answer("Circulatory system", true), answer("Digestive system"), answer("Skeletal system")]),
                    question("The respiratory system helps you...", [answer("Breathe", true), answer("Read"), answer("Hear music")])
                ]),
                lesson("biology-evolution", "Evolution", "biology", "Biology", .beginner, 5, "tortoise.fill", .green, "Learn how populations can change over many generations.", "Evolution is change in inherited traits over time. Helpful traits may become more common when they support survival and reproduction.", "If insects with camouflage survive more often, camouflage may become more common in that population.", 50, 20, "8 min", [
                    question("Evolution is change in inherited traits over...", [answer("Time", true), answer("One minute only"), answer("A single page")]),
                    question("Helpful traits may become more...", [answer("Common", true), answer("Invisible"), answer("Randomly erased")]),
                    question("Evolution happens in...", [answer("Populations", true), answer("Only one pencil"), answer("Empty rooms")])
                ])
            ]
        ),
        Subject(
            id: "programming-fundamentals",
            title: "Programming Fundamentals",
            iconName: "curlybraces",
            color: AppTheme.purpleAccent,
            lessons: [
                lesson("programming-variables", "Variables", "programming-fundamentals", "Programming Fundamentals", .beginner, 1, "shippingbox.fill", AppTheme.purpleAccent, "Use named containers to store information in a program.", "A variable stores a value so code can use it later. Good variable names describe what the value means.", "let score = 10 stores the number 10 in a variable named score.", 35, 20, "5 min", [
                    question("What does a variable do?", [answer("Stores a value", true), answer("Deletes the computer"), answer("Draws every image")]),
                    question("Which is a helpful variable name?", [answer("score", true), answer("xqz"), answer("thingy")]),
                    question("A variable can be used...", [answer("Later in code", true), answer("Only before it exists"), answer("Never")])
                ]),
                lesson("programming-loops", "Loops", "programming-fundamentals", "Programming Fundamentals", .beginner, 2, "repeat", AppTheme.purpleAccent, "Repeat instructions without writing the same code again and again.", "A loop runs a block of code multiple times. Loops are useful for lists, animations, games, and repeated tasks.", "A loop can print numbers 1 through 5 without five separate print statements.", 40, 20, "6 min", [
                    question("What does a loop do?", [answer("Repeats code", true), answer("Stops all programs forever"), answer("Changes the screen color only")]),
                    question("Loops help avoid...", [answer("Repeated code", true), answer("Readable names"), answer("Useful logic")]),
                    question("A loop is useful for processing...", [answer("A list of items", true), answer("Nothing"), answer("Only one letter")])
                ]),
                lesson("programming-conditionals", "Conditionals", "programming-fundamentals", "Programming Fundamentals", .beginner, 3, "switch.2", AppTheme.purpleAccent, "Make programs choose different actions based on conditions.", "A conditional checks whether something is true or false, then runs the matching code path.", "If score >= 100, show 'Level Up'; otherwise, keep playing.", 45, 20, "7 min", [
                    question("What does a conditional check?", [answer("Whether something is true or false", true), answer("Only spelling"), answer("The battery color")]),
                    question("Which word often starts a conditional?", [answer("if", true), answer("banana"), answer("always")]),
                    question("Conditionals help programs...", [answer("Make decisions", true), answer("Forget data"), answer("Avoid logic")])
                ]),
                lesson("programming-functions", "Functions", "programming-fundamentals", "Programming Fundamentals", .beginner, 4, "function", AppTheme.purpleAccent, "Group reusable steps under a clear name.", "A function is a named block of code. Functions make programs easier to read, test, and reuse.", "A calculateTotal() function can add prices whenever the app needs a total.", 45, 20, "7 min", [
                    question("What is a function?", [answer("A named block of reusable code", true), answer("A broken variable"), answer("A picture file")]),
                    question("Functions improve...", [answer("Reuse and organization", true), answer("Confusion"), answer("Random errors")]),
                    question("A good function name should describe...", [answer("What it does", true), answer("Nothing"), answer("Only its color")])
                ]),
                lesson("programming-arrays", "Arrays", "programming-fundamentals", "Programming Fundamentals", .beginner, 5, "list.bullet.rectangle.fill", AppTheme.purpleAccent, "Store multiple related values in order.", "An array holds a list of values. Programs use arrays for names, scores, lessons, messages, and many other collections.", "let scores = [8, 10, 7] stores three numbers in one ordered list.", 50, 20, "8 min", [
                    question("What does an array store?", [answer("A list of values", true), answer("Only one fixed word"), answer("Nothing")]),
                    question("Arrays are useful for...", [answer("Collections", true), answer("Avoiding data"), answer("Deleting loops")]),
                    question("In [8, 10, 7], how many values are there?", [answer("3", true), answer("1"), answer("25")])
                ])
            ]
        )
    ]

    static var beginnerLessons: [Lesson] {
        subjects.flatMap { $0.beginnerLessons }
    }

    static func subject(for lesson: Lesson) -> Subject? {
        subjects.first { $0.id == lesson.subjectID }
    }

    static func lesson(withID id: String) -> Lesson? {
        subjects.flatMap(\.lessons).first { $0.id == id }
    }

    private static func lesson(
        _ id: String,
        _ title: String,
        _ subjectID: String,
        _ subjectTitle: String,
        _ difficulty: LessonDifficulty,
        _ order: Int,
        _ iconName: String,
        _ color: Color,
        _ introduction: String,
        _ explanation: String,
        _ workedExample: String,
        _ xpReward: Int,
        _ badgeProgress: Int,
        _ estimatedTime: String,
        _ quizQuestions: [QuizQuestion]
    ) -> Lesson {
        Lesson(
            id: id,
            subjectID: subjectID,
            subjectTitle: subjectTitle,
            title: title,
            difficulty: difficulty,
            order: order,
            iconName: iconName,
            color: color,
            introduction: introduction,
            explanation: explanation,
            workedExample: workedExample,
            quizQuestions: quizQuestions,
            xpReward: xpReward,
            badgeProgress: badgeProgress,
            estimatedTime: estimatedTime
        )
    }

    private static func question(_ prompt: String, _ answers: [QuizAnswer]) -> QuizQuestion {
        QuizQuestion(prompt: prompt, answers: answers)
    }

    private static func answer(_ title: String, _ isCorrect: Bool = false) -> QuizAnswer {
        QuizAnswer(title: title, isCorrect: isCorrect)
    }
}
