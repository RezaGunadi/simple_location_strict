

class LayoutService{


  static double setHeight(var mediaQuery, double value){
    print("height:"+(mediaQuery.size.height*mediaQuery.devicePixelRatio).toString());
    print("width:"+(mediaQuery.size.width*mediaQuery.devicePixelRatio).toString());
    // if((mediaQuery.size.height*mediaQuery.devicePixelRatio) > 640){
    //   return value;
    // }else{
      double result = ((mediaQuery.size.height*mediaQuery.devicePixelRatio)*0.0015)*value*1.0;
    if(result > value) result= value;
    return result;
   // }
    
  }

  static double setWidth(var mediaQuery, double value){
    // if((mediaQuery.size.height*mediaQuery.devicePixelRatio) > 640){
    //   return value;
    // }else{
     double result =  ((mediaQuery.size.width*mediaQuery.devicePixelRatio)*0.0015)*value*1.0;
     print(result);
     if(result > value) result = value;
    return result;
    //}
  
  }
}