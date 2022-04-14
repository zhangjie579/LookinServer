//
//  LookinAttrIdentifiers.h
//  Lookin
//
//  Created by Li Kai on 2019/9/18.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

#pragma mark - Group

typedef NSString * LookinAttrGroupIdentifier;

extern LookinAttrGroupIdentifier const LookinAttrGroup_None;
extern LookinAttrGroupIdentifier const LookinAttrGroup_Class;
extern LookinAttrGroupIdentifier const LookinAttrGroup_Relation;
extern LookinAttrGroupIdentifier const LookinAttrGroup_Layout;
extern LookinAttrGroupIdentifier const LookinAttrGroup_AutoLayout;
extern LookinAttrGroupIdentifier const LookinAttrGroup_ViewLayer;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UIImageView;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UILabel;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UIControl;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UIButton;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UIScrollView;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UITableView;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UITextView;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UITextField;
extern LookinAttrGroupIdentifier const LookinAttrGroup_UIVisualEffectView;

extern LookinAttrGroupIdentifier const LookinAttrGroup_KcDebugMethod;

#pragma mark - Section

typedef NSString * LookinAttrSectionIdentifier;

extern LookinAttrSectionIdentifier const LookinAttrSec_None;

extern LookinAttrSectionIdentifier const LookinAttrSec_Class_Class;

extern LookinAttrSectionIdentifier const LookinAttrSec_Relation_Relation;

extern LookinAttrSectionIdentifier const LookinAttrSec_Layout_Frame;
extern LookinAttrSectionIdentifier const LookinAttrSec_Layout_Bounds;
extern LookinAttrSectionIdentifier const LookinAttrSec_Layout_SafeArea;
extern LookinAttrSectionIdentifier const LookinAttrSec_Layout_Position;
extern LookinAttrSectionIdentifier const LookinAttrSec_Layout_AnchorPoint;

extern LookinAttrSectionIdentifier const LookinAttrSec_AutoLayout_Hugging;
extern LookinAttrSectionIdentifier const LookinAttrSec_AutoLayout_Resistance;
extern LookinAttrSectionIdentifier const LookinAttrSec_AutoLayout_Constraints;
extern LookinAttrSectionIdentifier const LookinAttrSec_AutoLayout_IntrinsicSize;

extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Visibility;
extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_InterationAndMasks;
extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Corner;
extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_BgColor;
extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Border;
extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Shadow;
extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_ContentMode;
extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_TintColor;
extern LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Tag;

extern LookinAttrSectionIdentifier const LookinAttrSec_UIImageView_Name;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIImageView_Open;

extern LookinAttrSectionIdentifier const LookinAttrSec_UILabel_Text;
extern LookinAttrSectionIdentifier const LookinAttrSec_UILabel_Font;
extern LookinAttrSectionIdentifier const LookinAttrSec_UILabel_NumberOfLines;
extern LookinAttrSectionIdentifier const LookinAttrSec_UILabel_TextColor;
extern LookinAttrSectionIdentifier const LookinAttrSec_UILabel_BreakMode;
extern LookinAttrSectionIdentifier const LookinAttrSec_UILabel_Alignment;
extern LookinAttrSectionIdentifier const LookinAttrSec_UILabel_CanAdjustFont;

extern LookinAttrSectionIdentifier const LookinAttrSec_UIControl_EnabledSelected;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIControl_VerAlignment;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIControl_HorAlignment;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIControl_QMUIOutsideEdge;

extern LookinAttrSectionIdentifier const LookinAttrSec_UIButton_ContentInsets;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIButton_TitleInsets;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIButton_ImageInsets;

extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ContentInset;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_AdjustedInset;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_IndicatorInset;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_Offset;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ContentSize;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_Behavior;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ShowsIndicator;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_Bounce;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ScrollPaging;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ContentTouches;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_Zoom;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_QMUIInitialInset;

extern LookinAttrSectionIdentifier const LookinAttrSec_UITableView_Style;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITableView_SectionsNumber;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITableView_RowsNumber;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITableView_SeparatorStyle;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITableView_SeparatorColor;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITableView_SeparatorInset;

extern LookinAttrSectionIdentifier const LookinAttrSec_UITextView_Basic;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextView_Text;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextView_Font;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextView_TextColor;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextView_Alignment;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextView_ContainerInset;

extern LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Text;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Placeholder;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Font;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextField_TextColor;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Alignment;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Clears;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextField_CanAdjustFont;
extern LookinAttrSectionIdentifier const LookinAttrSec_UITextField_ClearButtonMode;

extern LookinAttrSectionIdentifier const LookinAttrSec_UIVisualEffectView_Style;
extern LookinAttrSectionIdentifier const LookinAttrSec_UIVisualEffectView_QMUIForegroundColor;


extern LookinAttrSectionIdentifier const LookinAttrSec_KcDebugMethod_Class;

#pragma mark - Attr

typedef NSString * LookinAttrIdentifier;

extern LookinAttrIdentifier const LookinAttr_None;

extern LookinAttrIdentifier const LookinAttr_Class_Class_Class;

extern LookinAttrIdentifier const LookinAttr_Relation_Relation_Relation;

extern LookinAttrIdentifier const LookinAttr_Layout_Frame_Frame;
extern LookinAttrIdentifier const LookinAttr_Layout_Bounds_Bounds;
extern LookinAttrIdentifier const LookinAttr_Layout_SafeArea_SafeArea;
extern LookinAttrIdentifier const LookinAttr_Layout_Position_Position;
extern LookinAttrIdentifier const LookinAttr_Layout_AnchorPoint_AnchorPoint;

extern LookinAttrIdentifier const LookinAttr_AutoLayout_Hugging_Hor;
extern LookinAttrIdentifier const LookinAttr_AutoLayout_Hugging_Ver;
extern LookinAttrIdentifier const LookinAttr_AutoLayout_Resistance_Hor;
extern LookinAttrIdentifier const LookinAttr_AutoLayout_Resistance_Ver;
extern LookinAttrIdentifier const LookinAttr_AutoLayout_Constraints_Constraints;
extern LookinAttrIdentifier const LookinAttr_AutoLayout_IntrinsicSize_Size;

extern LookinAttrIdentifier const LookinAttr_ViewLayer_Visibility_Hidden;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Visibility_Opacity;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_InterationAndMasks_Interaction;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Corner_Radius;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_BgColor_BgColor;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Border_Color;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Border_Width;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_Color;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_Opacity;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_Radius;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_OffsetW;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_OffsetH;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_ContentMode_Mode;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_TintColor_Color;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_TintColor_Mode;
extern LookinAttrIdentifier const LookinAttr_ViewLayer_Tag_Tag;

extern LookinAttrIdentifier const LookinAttr_UIImageView_Name_Name;
extern LookinAttrIdentifier const LookinAttr_UIImageView_Open_Open;

extern LookinAttrIdentifier const LookinAttr_UILabel_Text_Text;
extern LookinAttrIdentifier const LookinAttr_UILabel_Font_Name;
extern LookinAttrIdentifier const LookinAttr_UILabel_Font_Size;
extern LookinAttrIdentifier const LookinAttr_UILabel_NumberOfLines_NumberOfLines;
extern LookinAttrIdentifier const LookinAttr_UILabel_TextColor_Color;
extern LookinAttrIdentifier const LookinAttr_UILabel_Alignment_Alignment;
extern LookinAttrIdentifier const LookinAttr_UILabel_BreakMode_Mode;
extern LookinAttrIdentifier const LookinAttr_UILabel_CanAdjustFont_CanAdjustFont;

extern LookinAttrIdentifier const LookinAttr_UIControl_EnabledSelected_Enabled;
extern LookinAttrIdentifier const LookinAttr_UIControl_EnabledSelected_Selected;
extern LookinAttrIdentifier const LookinAttr_UIControl_VerAlignment_Alignment;
extern LookinAttrIdentifier const LookinAttr_UIControl_HorAlignment_Alignment;
extern LookinAttrIdentifier const LookinAttr_UIControl_QMUIOutsideEdge_Edge;

extern LookinAttrIdentifier const LookinAttr_UIButton_ContentInsets_Insets;
extern LookinAttrIdentifier const LookinAttr_UIButton_TitleInsets_Insets;
extern LookinAttrIdentifier const LookinAttr_UIButton_ImageInsets_Insets;

extern LookinAttrIdentifier const LookinAttr_UIScrollView_Offset_Offset;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_ContentSize_Size;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_ContentInset_Inset;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_AdjustedInset_Inset;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_Behavior_Behavior;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_IndicatorInset_Inset;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_ScrollPaging_PagingEnabled;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_Bounce_Ver;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_Bounce_Hor;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_ShowsIndicator_Hor;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_ShowsIndicator_Ver;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_ContentTouches_Delay;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_ContentTouches_CanCancel;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_Zoom_MinScale;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_Zoom_MaxScale;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_Zoom_Scale;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_Zoom_Bounce;
extern LookinAttrIdentifier const LookinAttr_UIScrollView_QMUIInitialInset_Inset;

extern LookinAttrIdentifier const LookinAttr_UITableView_Style_Style;
extern LookinAttrIdentifier const LookinAttr_UITableView_SectionsNumber_Number;
extern LookinAttrIdentifier const LookinAttr_UITableView_RowsNumber_Number;
extern LookinAttrIdentifier const LookinAttr_UITableView_SeparatorInset_Inset;
extern LookinAttrIdentifier const LookinAttr_UITableView_SeparatorColor_Color;
extern LookinAttrIdentifier const LookinAttr_UITableView_SeparatorStyle_Style;

extern LookinAttrIdentifier const LookinAttr_UITextView_Font_Name;
extern LookinAttrIdentifier const LookinAttr_UITextView_Font_Size;
extern LookinAttrIdentifier const LookinAttr_UITextView_Basic_Editable;
extern LookinAttrIdentifier const LookinAttr_UITextView_Basic_Selectable;
extern LookinAttrIdentifier const LookinAttr_UITextView_Text_Text;
extern LookinAttrIdentifier const LookinAttr_UITextView_TextColor_Color;
extern LookinAttrIdentifier const LookinAttr_UITextView_Alignment_Alignment;
extern LookinAttrIdentifier const LookinAttr_UITextView_ContainerInset_Inset;

extern LookinAttrIdentifier const LookinAttr_UITextField_Text_Text;
extern LookinAttrIdentifier const LookinAttr_UITextField_Placeholder_Placeholder;
extern LookinAttrIdentifier const LookinAttr_UITextField_Font_Name;
extern LookinAttrIdentifier const LookinAttr_UITextField_Font_Size;
extern LookinAttrIdentifier const LookinAttr_UITextField_TextColor_Color;
extern LookinAttrIdentifier const LookinAttr_UITextField_Alignment_Alignment;
extern LookinAttrIdentifier const LookinAttr_UITextField_Clears_ClearsOnBeginEditing;
extern LookinAttrIdentifier const LookinAttr_UITextField_Clears_ClearsOnInsertion;
extern LookinAttrIdentifier const LookinAttr_UITextField_CanAdjustFont_CanAdjustFont;
extern LookinAttrIdentifier const LookinAttr_UITextField_CanAdjustFont_MinSize;
extern LookinAttrIdentifier const LookinAttr_UITextField_ClearButtonMode_Mode;

extern LookinAttrIdentifier const LookinAttr_UIVisualEffectView_Style_Style;
extern LookinAttrIdentifier const LookinAttr_UIVisualEffectView_QMUIForegroundColor_Color;


extern LookinAttrIdentifier const LookinAttr_Kc_Debug_methodDesc;
