mod align;
mod stack;

fn main() {
    println!("Hello, Typst Layout!");

    // StackLayouterのテスト
    let layouter = stack::StackLayouter::new(align::align::Align::Start);
    layouter.layout();

    // CenterとEndのテスト
    let layouter_center = stack::StackLayouter::new(align::align::Align::Center);
    layouter_center.layout();

    let layouter_end = stack::StackLayouter::new(align::align::Align::End);
    layouter_end.layout();
}
