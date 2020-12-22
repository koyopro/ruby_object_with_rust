pub struct User {
    pub id: u64,
    pub name: String,
}

impl User {
    pub fn new(id: u64) -> User {
        User {
            id,
            name: "".to_string(),
        }
    }

    pub fn get_display(&self) -> String {
        format!("id: {}, name: {}", self.id, self.name)
    }
}

#[cfg(test)]
mod tests {
    use super::User;

    #[test]
    fn test_user() {
        let u = User {
            id: 1,
            name: "hoge".to_string(),
        };
        assert_eq!(&u.get_display(), "id: 1, name: hoge");
    }
}
