//
//  URLs.swift
//  Application
//
//  Created by 홍희표 on 2021/08/04.
//  Copyright © 2021 홍희표. All rights reserved.
//

let BASEURL = "http://hong227.dothome.co.kr/hong227/v1"
let URL_REGISTER = "\(BASEURL)/register"
let URL_LOGIN = "\(BASEURL)/login"
let URL_PROFILE_EDIT = "\(BASEURL)/profile"
let URL_POST = "\(BASEURL)/post"
let URL_POSTS = "\(BASEURL)/posts?group_id={GROUP_ID}&offset={OFFSET}"
let URL_USER_POSTS = "\(BASEURL)/posts/?offset={OFFSET}"
let URL_POST_LIKE = "\(BASEURL)/like/{POST_ID}"
let URL_POST_IMAGE = "\(BASEURL)/image"
let URL_POST_IMAGE_DELETE = "\(BASEURL)/images"
let URL_POST_IMAGE_PATH = "\(BASEURL)/php/Images/"
let URL_REPLYS = "\(BASEURL)/replys/{POST_ID}"
let URL_REPLY = "\(BASEURL)/replys/post/{REPLY_ID}" // 댓글 url

let URL_USER_PROFILE_IMAGE = "\(BASEURL)/php/ProfileImages/"

let URL_GROUP = "\(BASEURL)/group"
let URL_GROUPS = "\(BASEURL)/groups?offset={OFFSET}"
let URL_USER_GROUP = "\(BASEURL)/user_groups?offset={OFFSET}"
