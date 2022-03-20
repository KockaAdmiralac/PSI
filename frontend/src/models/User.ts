interface User {
    username: string;
    profileURL: string;
    
    // User page view:
    profilePhotoURL: string;
    realName : string;
    numberOfPosts : number;
    numberOfFollowers : number;
    numberFollowing : number;

    // Does the curent user follow this person
    amFollowing: boolean;
}

export default User;
