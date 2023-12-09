fn main()
{
    ex002();
}

fn ex002()
{
    // 9:40
    let mut x: i32 = 1;
    x += 2;

    assert_eq!(x, 3);
    println!("success");
}


fn ex001()
{
    // 6:46
    // binding and mutability
    // a variable can only be used after initialize it's value

    let x_prev: i32;  // uninitialized & used; error
    let y_prev: i32;  // uninitialized & unuased; warning

    let x: i32 = 5;
    let _y: i32;

    assert_eq!(x, 5);
    println!("success");
}
