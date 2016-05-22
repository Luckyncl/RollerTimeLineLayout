# RollerTimeLineLayout
A collection view layout with roller effect.

## Introduction
This is an implementation for the collection view layout below:

![](https://raw.githubusercontent.com/StanOz/RollerTimeLineLayo<!---->ut/master/rollerLayoutDemo.gif)  

`RollerLayout.h` could be used in storyboard and the property `margin` is inspectable. So the following code is used to fetching margin to adjust collectionView's offset.

    _margin = ((RollerLayout *)self.collectionView.collectionViewLayout).margin;

I hope that you could contact me if you have a better implementation :)

##License
All source code is licensed under the [MIT License](https://raw.githubusercontent.com/StanOz/TableViewCellTransitionDemo/master/LICENSE).